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
        do {
            let viewModel = try MoviesViewModel()
            let moviesViewController = MoviesViewController(viewModel: viewModel, dependencies: self.dependencies)
            moviesViewController.delegate = self
            self.window.rootViewController = moviesViewController
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
