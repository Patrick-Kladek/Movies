//
//  Router.swift
//  Movies
//
//  Created by Patrick Kladek on 03.10.22.
//

import UIKit
import os.log

final class Router {

    private let window: UIWindow
    private let dependencies = GlobalDependencies()
    private var viewModel: MoviesViewModel?

    // MARK: - Lifecycle

    init(window: UIWindow) {
        self.window = window
    }

    // MARK: - Router

    func start() {
//        let viewModel = try! MoviesViewModel()
//        let movies = (viewModel.favorites + viewModel.staffPicks).uniqued()
//        let searchViewController = SearchViewController(movies: movies, dependencies: self.dependencies)
//        searchViewController.delegate = self
//
//        let navigationController = UINavigationController(rootViewController: searchViewController)
//        navigationController.setNavigationBarHidden(true, animated: false)
//
//        self.window.rootViewController = navigationController
//        self.window.makeKeyAndVisible()
//
//        return


        do {
            let viewModel = try MoviesViewModel()
            defer {
                self.viewModel = viewModel
            }

            let moviesViewController = MoviesViewController(viewModel: viewModel, dependencies: self.dependencies)
            moviesViewController.delegate = self

            let navigationController = UINavigationController(rootViewController: moviesViewController)
            navigationController.setNavigationBarHidden(true, animated: false)

            self.window.rootViewController = navigationController
            self.window.makeKeyAndVisible()
        } catch LoadingError.fileMissing(let name) {
            fatalError("Could not load movies with name: \(name). Check Build Pipeline")
        } catch {
            fatalError("Error loading Movies")
        }
    }
}

// MARK: - MoviesViewControllerDelegate

extension Router: MoviesViewControllerDelegate {

    func moviesViewControllerDidSelectSearch(_ viewController: MoviesViewController) {
        guard let viewModel = self.viewModel else {
            Logger.router.error("View Model is nil, abort")
            return
        }

        let searchViewController = SearchViewController(movies: viewModel.allMovies, dependencies: self.dependencies)
        searchViewController.delegate = self

        viewController.navigationController?.pushViewController(searchViewController, animated: true)
    }

    func moviesViewControllerDidSelectSeeAll(_ viewController: MoviesViewController) {
        // Same App Flow
        self.moviesViewControllerDidSelectSearch(viewController)
    }

    func moviesViewController(_ viewController: MoviesViewController, didSelect movie: Movie) {
        let detailViewController = DetailViewController(movie: movie, dependencies: self.dependencies)
        let navigationController = UINavigationController(rootViewController: detailViewController)
        navigationController.overrideUserInterfaceStyle = .light
        viewController.present(navigationController, animated: true)
    }
}

// MARK: - SearchViewControllerDelegate

extension Router: SearchViewControllerDelegate {

    func searchViewController(_ viewController: SearchViewController, didSelect movie: Movie) {
        let detailViewController = DetailViewController(movie: movie, dependencies: self.dependencies)
        let navigationController = UINavigationController(rootViewController: detailViewController)
        navigationController.overrideUserInterfaceStyle = .light
        viewController.present(navigationController, animated: true)
    }
}
