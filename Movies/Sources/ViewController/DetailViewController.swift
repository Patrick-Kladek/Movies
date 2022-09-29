//
//  DetailViewController.swift
//  Movies
//
//  Created by Patrick Kladek on 28.09.22.
//

import UIKit

final class DetailViewController: UICollectionViewController {

    private let movie: Movie

//    private lazy var layout: UICollectionViewLayout = self.makeLayout()
    private lazy var dateFormatter: DateFormatter = self.makeDateFormatter()
    private lazy var yearFormatter: DateFormatter = self.makeYearFormatter()
    private lazy var timeFormatter: DateComponentsFormatter = self.makeTimeFormatter()

    // MARK: - Lifecycle

    init(movie: Movie) {
        self.movie = movie

        // NOTE: Workaround, see viewDidLoad for explaination
        super.init(collectionViewLayout: .init())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = self.movie.title

        // NOTE: Workaround so UICollectionViewCompositionalLayout can access the dataSource
        // and correctly center the Genre Cells
        self.collectionView.collectionViewLayout = self.makeLayout()
        self.collectionViewLayout.invalidateLayout()

        self.collectionView.registerReusableCell(PosterCell.self)
        self.collectionView.registerReusableCell(FactsCell.self)
        self.collectionView.registerReusableCell(GenreCell.self)
        self.collectionView.registerReusableCell(RatingCell.self)
        self.collectionView.registerReusableCell(TextCell.self)
        self.collectionView.registerReusableCell(PlaceholderCell.self)
        self.collectionView.registerReusableSupplementaryView(HeaderCell.self)
    }

    // MARK: - UICollectionViewController

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0...1:
            return 1
        case 2:
            return self.movie.genres.count
        case 3:
            return 1
        case 4:
            return self.movie.cast.count
        case 5:
            return self.movie.revenue == nil ? 3 : 4
        default:
            return 0
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell: PosterCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            cell.backgroundColor = .quaternarySystemFill
            cell.image = movie.image
            return cell
        case 1:
            let cell: FactsCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            cell.configure(with: self.movie, dateFormatter: self.dateFormatter, yearFormatter: self.yearFormatter, timeFormatter: self.timeFormatter)
            return cell
        case 2:
            let cell: GenreCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            cell.label.text = self.movie.genres[indexPath.row]
            return cell
        case 3:
            let cell: TextCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            cell.label.text = self.movie.overview
            return cell
        default:
            let cell: PlaceholderCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            return cell
        }

    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell: HeaderCell = collectionView.dequeueReusableSupplementaryView(indexPath: indexPath)

        switch indexPath.section {
        case 3:
            cell.text = NSLocalizedString("Overview", comment: "Label. Short. Home-Screen. Title for Favourites Section")
            cell.textColor = Asset.Colors.highEmphasis.color
        case 4:
            cell.text = NSLocalizedString("OUR *STAFF PICKS*", comment: "Label. Short. Home-Screen. Title for Favourites Section")
            cell.textColor = Asset.Colors.highEmphasis.color
        default:
            break
        }

        return cell
    }

    // MARK: - DetailViewController
}

// MARK: - Private

private extension DetailViewController {

    func makeLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case 0:
                return self.makeImageSection(layoutEnvironment: layoutEnvironment)
            case 1:
                return self.makeFactsSection(layoutEnvironment: layoutEnvironment)
            case 2:
                return self.makeGenreSection(layoutEnvironment: layoutEnvironment)
            case 3:
                return self.makeOverViewSection(layoutEnvironment: layoutEnvironment)

            case 4:
                return Self.makeDirectorSection(layoutEnvironment: layoutEnvironment)
            case 5:
                return Self.makeActorsSection(layoutEnvironment: layoutEnvironment)
            case 6:
                return Self.makeKeyFactsSection(layoutEnvironment: layoutEnvironment)
            default:
                return nil
            }
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 0

        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: config)
        return layout
    }

    func makeImageSection(layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let targetSize = CGSize(width: 203, height: 295)

        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(targetSize.width),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(targetSize.height))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none

        let spacing = (layoutEnvironment.container.contentSize.width - targetSize.width) / 2
        section.contentInsets = NSDirectionalEdgeInsets(top: 30, leading: spacing, bottom: 0, trailing: spacing)

        return section
    }

    func makeFactsSection(layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(107))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(107))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 19, leading: 0, bottom: 0, trailing: 0)

        return section
    }

    func makeGenreSection(layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let itemCount = self.collectionView.numberOfItems(inSection: 2)
        let cell = GenreCell(frame: .zero)
        let cellSizes: [CGSize] = (0..<itemCount).compactMap {
            cell.label.text = self.movie.genres[$0]
            return cell.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        }

        let group = NSCollectionLayoutGroup.verticallyCentered(cellSizes: cellSizes)
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 47, trailing: 0)
        return section
    }

    func makeOverViewSection(layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 20, bottom: 0, trailing: 20)

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(20.0))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: UICollectionView.elementKindSectionHeader,
                                                                 alignment: .top)
        section.boundarySupplementaryItems = [header]

        return section
    }





    static func makeGenreSection(layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let estimatedHeight: CGFloat = 20

        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(50),
                                              heightDimension: .estimated(estimatedHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.edgeSpacing = .init(leading: .flexible(10), top: nil, trailing: .flexible(10), bottom: nil)

        // if we have the space, adapt and go 2-up + peeking 3rd item
        let groupFractionalWidth = CGFloat(layoutEnvironment.container.effectiveContentSize.width > 500 ? 0.425 : 0.85)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(groupFractionalWidth),
                                               heightDimension: .estimated(estimatedHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.edgeSpacing = .init(leading: .flexible(10), top: nil, trailing: .flexible(10), bottom: nil)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.interGroupSpacing = 11
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)

        return section
    }

    static func makeReleaseDateSection(layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(100),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(15))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 19, leading: 0, bottom: 0, trailing: 0)

        return section
    }

    static func makeTitleSection(layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(15))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 19, leading: 0, bottom: 0, trailing: 0)

        return section
    }

    static func makeOverViewSection(layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
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

    static func makeDirectorSection(layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
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

    static func makeActorsSection(layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
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

    static func makeKeyFactsSection(layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
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

    func makeDateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }

    func makeYearFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }

    func makeTimeFormatter() -> DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute]
        return formatter
    }
}
