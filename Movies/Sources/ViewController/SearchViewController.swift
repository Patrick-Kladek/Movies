//
//  SearchViewController.swift
//  Movies
//
//  Created by Patrick Kladek on 03.10.22.
//

import UIKit
import Combine
import os.log

protocol SearchViewControllerDelegate: AnyObject {
    func searchViewController(_ viewController: SearchViewController, didSelect movie: Movie)
}

final class SearchViewController: UIViewController {

    typealias Dependencies = HasNetworkManager

    private let dependencies: Dependencies

    private lazy var searchContainer: UIView = self.makeSearchContainer()
    private lazy var backButton: UIButton = self.makeBackButton()
    private lazy var searchField: UITextField = self.makeSearchField()
    private lazy var collectionView: UICollectionView = self.makeCollectionView()
    private lazy var filterViewController: FilterViewController = self.makeFilterViewController()
    private lazy var shadowView: UIView = self.makeShadowView()

    private var cancelables: [AnyCancellable] = []
    private var movies: Movies
    private var currentMovies: Movies = []

    weak var delegate: SearchViewControllerDelegate?

    // MARK: - Lifecycle

    init(movies: Movies, dependencies: Dependencies) {
        self.movies = movies
        self.currentMovies = movies
        self.dependencies = dependencies
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIViewController

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.overrideUserInterfaceStyle = .dark
        self.view.backgroundColor = Asset.Colors.background.color
        self.setup()

        self.collectionView.registerReusableCell(MovieCell.self)
        self.collectionView.keyboardDismissMode = .onDrag

        self.filterViewController.$filter.sink { [weak self] filterValue in
            guard let self else { return }

            self.currentMovies = self.movies.filter { movie in
                if filterValue == .noFilter { return true }

                return Int(round(movie.rating)) == filterValue.rawValue
            }
            self.collectionView.reloadData()
        }.store(in: &self.cancelables)

        AppDefaults.$bookmarked.sink { [weak self] _ in
            self?.collectionView.reloadData()
        }.store(in: &self.cancelables)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let bottomInset = self.view.safeAreaInsets.bottom + 12
        self.collectionView.scrollIndicatorInsets = .init(top: 0, left: 0, bottom: bottomInset, right: 0)
    }
}

// MARK: - UICollectionViewDataSource

extension SearchViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.currentMovies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let movie = self.currentMovies[indexPath.row]
        let cell: MovieCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        cell.configure(with: movie, dateFormatter: .yearFormatter)
        cell.isFavourite = AppDefaults.bookmarked.contains(movie.id)
        cell.delegate = self

        Task {
            do {
                let image = try await self.dependencies.networkManager.loadThumbnail(for: movie)
                cell.image = image
            } catch {
                Logger.searchViewController.error("Failed to load thumbnail: \(error.localizedDescription)")
            }
        }

        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension SearchViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = self.currentMovies[indexPath.row]
        self.delegate?.searchViewController(self, didSelect: movie)
    }
}

// MARK: - MovieCellDelegate

extension SearchViewController: MovieCellDelegate {

    func movieCellBookmarkChanged(_ cell: MovieCell) {
        guard let indexPath = self.collectionView.indexPath(for: cell) else { return }

        let movie = self.currentMovies[indexPath.row]
        if cell.isFavourite {
            AppDefaults.bookmarked.append(movie.id)
        } else {
            AppDefaults.bookmarked.removeAll { movie.id == $0 }
        }
    }
}

// MARK: - UITextFieldDelegate

extension SearchViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.currentMovies = self.movies.filter {
            guard let text = textField.text else { return true }
            guard text.isEmpty == false else { return true }

            return $0.title.contains(text)
        }
        self.collectionView.reloadData()

        return true
    }
}

// MARK: - Private

private extension SearchViewController {

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
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        return button
    }

    func makeSearchField() -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
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

    func makeShadowView() -> UIView {
        let view = GradientView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.colors = [Asset.Colors.background.color, .clear]
        return view
    }

    func makeCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout { _, layoutEnvironment in
            return Self.makeListSection(layoutEnvironment: layoutEnvironment)
        }

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.automaticallyAdjustsScrollIndicatorInsets = false
        collectionView.backgroundColor = .clear
        return collectionView
    }

    func setup() {
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

        self.view.addSubview(self.shadowView)
        NSLayoutConstraint.activate([
            self.shadowView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.shadowView.topAnchor.constraint(equalTo: self.filterViewController.view.bottomAnchor),
            self.shadowView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.shadowView.heightAnchor.constraint(equalToConstant: 56)
        ])
    }

    @objc
    func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
