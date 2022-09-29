//
//  DetailViewController.swift
//  Movies
//
//  Created by Patrick Kladek on 28.09.22.
//

import UIKit

final class DetailViewController: UICollectionViewController {

    private let movie: Movie

    private lazy var dateFormatter: DateFormatter = self.makeDateFormatter()
    private lazy var timeFormatter: RelativeDateTimeFormatter = self.makeTimeFormatter()

    // MARK: - Lifecycle

    init(movie: Movie) {
        self.movie = movie
        super.init(collectionViewLayout: Self.makeLayout())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.registerReusableCell(PosterCell.self)
        self.collectionView.registerReusableCell(RatingCell.self)
        self.collectionView.registerReusableCell(TextCell.self)
        self.collectionView.registerReusableCell(PlaceholderCell.self)
        self.title = self.movie.title
    }

    // MARK: - UICollectionViewController

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0...2:
            return 1
        case 3:
            return self.movie.cast.count
        case 4:
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
            return cell
        case 1:
            let cell: RatingCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            cell.backgroundColor = .quaternarySystemFill
            return cell
        case 2:
            let cell: TextCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            let dateString = self.dateFormatter.string(from: self.movie.releaseDate)
            let timeString = self.timeFormatter.localizedString(fromTimeInterval: Double(self.movie.runtime))
            cell.label.text = "\(dateString )  ·  \(timeString)"
            return cell
        default:
            let cell: PlaceholderCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            return cell
        }

    }

    // MARK: - DetailViewController
}

// MARK: - Private

private extension DetailViewController {

    static func makeLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case 0:
                return self.makeImageSection(layoutEnvironment: layoutEnvironment)
            case 1:
                return self.makeRatingSection(layoutEnvironment: layoutEnvironment)
            case 2:
                return self.makeReleaseDateSection(layoutEnvironment: layoutEnvironment)
            case 3:
                return self.makeTitleSection(layoutEnvironment: layoutEnvironment)
            case 4:
                return self.makeDirectorSection(layoutEnvironment: layoutEnvironment)
            case 5:
                return self.makeActorsSection(layoutEnvironment: layoutEnvironment)
            case 6:
                return self.makeKeyFactsSection(layoutEnvironment: layoutEnvironment)
            default:
                return nil
            }
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()

        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: config)
        return layout
    }

    static func makeImageSection(layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let targetSize = CGSize(width: 203, height: 295)

        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(targetSize.width),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(targetSize.height))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous

        let spacing = (layoutEnvironment.container.contentSize.width - targetSize.width) / 2
        section.contentInsets = NSDirectionalEdgeInsets(top: 30, leading: spacing, bottom: 0, trailing: spacing)

        return section
    }

    static func makeRatingSection(layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
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

    func makeTimeFormatter() -> RelativeDateTimeFormatter {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        formatter.dateTimeStyle = .numeric
        return formatter
    }
}
