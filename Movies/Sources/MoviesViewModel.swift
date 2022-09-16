//
//  MoviesViewModel.swift
//  Movies
//
//  Created by Patrick Kladek on 16.09.22.
//

import Foundation

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
