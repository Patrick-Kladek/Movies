//
//  Router.swift
//  Movies
//
//  Created by Patrick Kladek on 03.10.22.
//

import UIKit

final class Router {

    private let window: UIWindow
    private let dependencies = GlobalDependencies()

    // MARK: - Lifecycle

    init(window: UIWindow) {
        self.window = window
    }

    // MARK: - Router

    func start() {
        let searchViewController = SearchViewController()
        self.window.rootViewController = searchViewController
        self.window.makeKeyAndVisible()

        return


        do {
            let viewModel = try MoviesViewModel()
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
        print(#function)
    }

    func moviesViewControllerDidSelectSeeAll(_ viewController: MoviesViewController) {
        print(#function)
    }

    func moviesViewController(_ viewController: MoviesViewController, didSelect movie: Movie) {
        let detailViewController = DetailViewController(movie: movie, dependencies: self.dependencies)
        let navigationController = UINavigationController(rootViewController: detailViewController)
        navigationController.overrideUserInterfaceStyle = .light
        viewController.present(navigationController, animated: true)
    }
}

// MAKR: - Private

private extension Router {


}
