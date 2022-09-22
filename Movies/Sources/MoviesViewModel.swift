//
//  MoviesViewModel.swift
//  Movies
//
//  Created by Patrick Kladek on 16.09.22.
//

import UIKit

enum LoadingError: Error {
    case fileMissing(name: String)
}

struct MoviesViewModel {

    let favorites: Movies
    let staffPicks: Movies

    init() throws {
        self.favorites = try Self.loadMovies(named: "movies")
        self.staffPicks = try Self.loadMovies(named: "staff_picks")
    }
}

// MARK: - Movies

private var associateMovieImageKey: Void?

extension Movie {

    var image: UIImage? {
        get {
            return objc_getAssociatedObject(self, &associateMovieImageKey) as? UIImage
        }
        set {
            objc_setAssociatedObject(self, &associateMovieImageKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}

// MARK: - Private

private extension MoviesViewModel {

    static func loadMovies(named name: String) throws -> Movies {
        guard let url = Bundle.main.url(forResource: name, withExtension: "json") else {
            throw LoadingError.fileMissing(name: name)
        }

        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(Movies.self, from: data)
    }
}
