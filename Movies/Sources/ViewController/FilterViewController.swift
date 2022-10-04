//
//  FilterViewController.swift
//  Movies
//
//  Created by Patrick Kladek on 04.10.22.
//

import UIKit

final class FilterViewController: UICollectionViewController {

    enum Filter: Int {
        case star5 = 0
        case star4 = 1
        case star3 = 2
        case star2 = 3
        case star1 = 4
        case noFilter = 5
    }

    private(set) var filter: Filter = .noFilter

    // MARK: - Lifecycle

    init() {
        let layout = UICollectionViewCompositionalLayout { _, layoutEnvironment in
            return Self.makeSliderSection(layoutEnvironment: layoutEnvironment)
        }
        super.init(collectionViewLayout: layout)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.registerReusableCell(RatingCell.self)
        self.collectionView.backgroundColor = .clear
    }

    // MARK: - UICollectionView

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: RatingCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        cell.configure(with: 5 - indexPath.row)
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.filter.rawValue == indexPath.row {
            self.filter = .noFilter
            collectionView.deselectItem(at: indexPath, animated: true)
        } else {
            self.filter = Filter(rawValue: indexPath.row)!
        }
    }
}

// MARK: - Private

private extension FilterViewController {

    static func makeSliderSection(layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let estimatedHeight: CGFloat = 29
        let estimatedWidth: CGFloat = 57

        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(estimatedWidth),
                                              heightDimension: .absolute(estimatedHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(estimatedWidth),
                                               heightDimension: .estimated(estimatedHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 20
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 46, bottom: 0, trailing: 46)

        return section
    }
}
