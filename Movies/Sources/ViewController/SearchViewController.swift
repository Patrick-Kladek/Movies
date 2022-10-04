//
//  SearchViewController.swift
//  Movies
//
//  Created by Patrick Kladek on 03.10.22.
//

import UIKit

final class SearchViewController: UIViewController {

    enum Filter: Int {
        case star5 = 0
        case star4 = 1
        case star3 = 2
        case star2 = 3
        case star1 = 4
        case noFilter = 5
    }

    private lazy var searchContainer: UIView = self.makeSearchContainer()
    private lazy var backButton: UIButton = self.makeBackButton()
    private lazy var searchField: UITextField = self.makeSearchField()
    private lazy var collectionView: UICollectionView = self.makeCollectionView()
    private lazy var filterViewController: FilterViewController = self.makeFilterViewController()

    private var filter: Filter = .noFilter

    // MARK: - Lifecycle

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        self.overrideUserInterfaceStyle = .dark
        self.setup()

        self.collectionView.registerReusableCell(PlaceholderCell.self)
    }
}

// MARK: - UICollectionViewDataSource

extension SearchViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PlaceholderCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension SearchViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }

        if self.filter.rawValue == indexPath.row {
            self.filter = .noFilter
            collectionView.deselectItem(at: indexPath, animated: true)
        } else {
            self.filter = Filter(rawValue: indexPath.row)!
        }
    }
}

// MARK: - Private

private extension SearchViewController {

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

    func makeSearchContainer() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Asset.Colors.elevated.color
        view.layer.cornerRadius = 12
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1.0
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 30
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 0, height: 3)

        view.addSubview(self.backButton)
        NSLayoutConstraint.activate([
            self.backButton.imageView!.topAnchor.constraint(equalTo: view.topAnchor, constant: 17),
            self.backButton.imageView!.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 17),
            self.backButton.imageView!.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -17),
            self.backButton.heightAnchor.constraint(equalTo: self.backButton.widthAnchor, multiplier: 1.0)
        ])

        view.addSubview(self.searchField)
        NSLayoutConstraint.activate([
            self.searchField.leadingAnchor.constraint(equalTo: self.backButton.trailingAnchor, constant: 20),
            self.searchField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            self.searchField.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        return view
    }

    func makeBackButton() -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(Asset.Images.back.image, for: .normal)
        return button
    }

    func makeSearchField() -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(string: "Search all movies", attributes: [
            .foregroundColor: Asset.Colors.lowEmphasisLight.color,
            .font: TextStyle.input.font
        ])

        return textField
    }

    func makeFilterViewController() -> FilterViewController {
        let viewController = FilterViewController()
        return viewController
    }

    func makeCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout { _, layoutEnvironment in
            return Self.makeListSection(layoutEnvironment: layoutEnvironment)
        }

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }

    func setup() {
        self.view.backgroundColor = Asset.Colors.background.color
        self.view.addSubview(self.searchContainer)
        NSLayoutConstraint.activate([
            self.searchContainer.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 13),
            self.searchContainer.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            self.searchContainer.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -30)
        ])

        self.view.addSubview(self.filterViewController.view)
        self.filterViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.filterViewController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.filterViewController.view.topAnchor.constraint(equalTo: self.searchContainer.bottomAnchor, constant: 20),
            self.filterViewController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.filterViewController.view.heightAnchor.constraint(equalToConstant: 29)
        ])


        self.view.addSubview(self.collectionView)
        NSLayoutConstraint.activate([
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.collectionView.topAnchor.constraint(equalTo: self.filterViewController.view.bottomAnchor, constant: 15),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
}
