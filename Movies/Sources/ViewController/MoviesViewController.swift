//
//  MoviesViewController.swift
//  Movies
//
//  Created by Patrick Kladek on 16.09.22.
//

import os.log
import UIKit

class MoviesViewController: UICollectionViewController {

    typealias Dependencies = HasNetworkManager

    private lazy var yearDateFormatter: DateFormatter = self.makeYearDateFormatter()

    private let viewModel: MoviesViewModel
    private let dependencies: Dependencies
    private var backgroundImageView: UIImageView?

    // MARK: - Private

    init(viewModel: MoviesViewModel, dependencies: Dependencies) {
        self.viewModel = viewModel
        self.dependencies = dependencies
        let layout = Self.makeLayout()
        super.init(collectionViewLayout: layout)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        self.overrideUserInterfaceStyle = .dark
        self.view.backgroundColor = .white
        self.collectionView.backgroundColor = .clear
        self.collectionView.registerReusableCell(SearchCell.self)
        self.collectionView.registerReusableCell(PosterCell.self)
        self.collectionView.registerReusableCell(MovieCell.self)
        self.collectionView.registerReusableCell(MoreCell.self)
        self.collectionView.registerReusableSupplementaryView(HeaderCell.self)

        // Background.png top curve is about 62px tall
        let capInsets = UIEdgeInsets(top: 65, left: 0, bottom: 0, right: 0)
        let image = UIImage(named: "Background")?.resizableImage(withCapInsets: capInsets, resizingMode: .stretch)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.insertSubview(imageView, at: 0)
        NSLayoutConstraint.activate([
            imageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            imageView.topAnchor.constraint(equalTo: self.collectionView.contentLayoutGuide.topAnchor, constant: 268),
            imageView.widthAnchor.constraint(equalTo: self.collectionView.widthAnchor)
        ])
        self.backgroundImageView = imageView
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        guard let view = self.backgroundImageView else { return }
        self.collectionView.sendSubviewToBack(view)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    // MARK: UICollectionViewController

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return self.viewModel.favorites.count + 1
        case 2:
            return self.viewModel.staffPicks.count
        default:
            return 0
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell: SearchCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            return cell
        case 1:
            if indexPath.row > 0, indexPath.row == self.viewModel.favorites.count {
                let cell: MoreCell = collectionView.dequeueReusableCell(indexPath: indexPath)

                return cell
            }
            let movie = self.viewModel.favorites[indexPath.row]
            let cell: PosterCell = collectionView.dequeueReusableCell(indexPath: indexPath)

            Task {
                do {
                    let image = try await self.dependencies.networkManager.loadThumbnail(for: movie)
                    cell.image = image
                } catch {
                    Logger.moviesViewController.error("Failed to load thumbnail: \(error.localizedDescription)")
                }
            }
            return cell
        case 2:
            let movie = self.viewModel.staffPicks[indexPath.row]
            let cell: MovieCell = collectionView.dequeueReusableCell(indexPath: indexPath)

            cell.configure(with: movie, dateFormatter: self.yearDateFormatter)
            cell.isFavourite = AppDefaults.bookmarked.contains(movie.id)
            cell.delegate = self

            Task {
                do {
                    let image = try await self.dependencies.networkManager.loadThumbnail(for: movie)
                    cell.image = image
                } catch {
                    Logger.moviesViewController.error("Failed to load thumbnail: \(error.localizedDescription)")
                }
            }
            return cell
        default:
            fatalError("Missing Cell for CollectionView Section")
        }
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell: HeaderCell = collectionView.dequeueReusableSupplementaryView(indexPath: indexPath)

        switch indexPath.section {
        case 1:
            cell.attributedTitle = NSLocalizedString("YOUR *FAVORITES*", comment: "Label. Short. Home-Screen. Title for Favourites Section").parseMarkup()
            cell.textColor = .black
        case 2:
            cell.attributedTitle = NSLocalizedString("OUR *STAFF PICKS*", comment: "Label. Short. Home-Screen. Title for Favourites Section").parseMarkup()
            cell.textColor = .white
        default:
            break
        }

        return cell
    }
}

// MARK: - MovieCellDelegate

extension MoviesViewController: MovieCellDelegate {

    func movieCellBookmarkChanged(_ cell: MovieCell) {
        guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
        guard indexPath.section == 2 else { return }

        let movie = self.viewModel.staffPicks[indexPath.row]
        if cell.isFavourite {
            AppDefaults.bookmarked.append(movie.id)
        } else {
            AppDefaults.bookmarked.removeAll { movie.id == $0 }
        }
    }
}

// MARK: - Private

private extension MoviesViewController {

    static func makeLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case 0:
                return self.makeSearchSection(layoutEnvironment: layoutEnvironment)
            case 1:
                return self.makeSliderSection(layoutEnvironment: layoutEnvironment)
            default:
                return self.makeListSection(layoutEnvironment: layoutEnvironment)
            }
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()

        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: config)
        return layout
    }

    static func makeSearchSection(layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(48),
                                               heightDimension: .absolute(48))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 50, trailing: 20)

        return section
    }

    static func makeSliderSection(layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let estimatedHeight: CGFloat = 270

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .absolute(estimatedHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupFractionalWidth = 0.5
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(groupFractionalWidth),
                                               heightDimension: .estimated(estimatedHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 30
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 41.5, trailing: 20)

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(20.0))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: UICollectionView.elementKindSectionHeader,
                                                                 alignment: .top)
        section.boundarySupplementaryItems = [header]

        return section
    }

    static func makeListSection(layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let estimatedHeight: CGFloat = 141

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(estimatedHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(estimatedHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0)

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(20.0))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: UICollectionView.elementKindSectionHeader,
                                                                 alignment: .top)
        header.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        section.boundarySupplementaryItems = [header]

        return section
    }

    func makeYearDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter
    }
}
