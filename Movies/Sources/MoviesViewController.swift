//
//  MoviesViewController.swift
//  Movies
//
//  Created by Patrick Kladek on 16.09.22.
//

import UIKit

class MoviesViewController: UICollectionViewController {

    let viewModel: MoviesViewModel

    // MARK: - Private

    init(viewModel: MoviesViewModel) {
        self.viewModel = viewModel
        let layout = Self.makeLayout()
        super.init(collectionViewLayout: layout)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.collectionView.backgroundColor = .clear
//        self.collectionView.contentInsetAdjustmentBehavior = .never
        self.collectionView.registerReusableCell(SearchCell.self)
        self.collectionView.registerReusableCell(MovieCell.self)
        self.collectionView.registerReusableSupplementaryView(HeaderCell.self)
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
            return self.viewModel.favorites.count
        case 2:
            return self.viewModel.staffPicks.count
        default:
            return 0
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell: SearchCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            return cell
        }
        let cell: MovieCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        cell.backgroundColor = .blue
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell: HeaderCell = collectionView.dequeueReusableSupplementaryView(indexPath: indexPath)

        switch indexPath.section {
        case 1:
            cell.attributedTitle = NSLocalizedString("YOUR *FAVORITES*", comment: "Label. Short. Home-Screen. Title for Favourites Section").parseMarkup()
        case 2:
            cell.attributedTitle = NSLocalizedString("OUR *STAFF PICKS*", comment: "Label. Short. Home-Screen. Title for Favourites Section").parseMarkup()
        default:
            break
        }

        return cell
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
                                              heightDimension: .estimated(estimatedHeight))
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

        let groupFractionalWidth = 1.0
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(groupFractionalWidth),
                                               heightDimension: .estimated(estimatedHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 15  // TODO: reduce to zero based on design
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20)

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(20.0))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: UICollectionView.elementKindSectionHeader,
                                                                 alignment: .top)
        section.boundarySupplementaryItems = [header]

        return section
    }
}
