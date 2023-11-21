//
//  NetworkManager.swift
//  Movies
//
//  Created by Patrick Kladek on 22.09.22.
//

import UIKit
import os.log

final class NetworkManager {

    enum NetworkError: Error {
        case missingURL
        case invalidImageFormat
    }

    static let shared = NetworkManager()

    private init() { }

    // MARK: - NetworkManager

    func loadThumbnail(for movie: Movie) async throws -> UIImage {
        if let image = movie.image {
            return image
        }

        guard let url = URL(string: movie.posterURL) else {
            Logger.networkManager.error("Invalid URL for movie: \(movie.id), url: \(movie.posterURL)")
            throw NetworkError.missingURL
        }

        let request = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)

        guard let image = UIImage(data: data) else {
            Logger.networkManager.error("Invalid Image for movie: \(movie.id), data: \(data)")
            throw NetworkError.invalidImageFormat
        }

        movie.image = image
        return image
    }

    func loadThumbnail(for director: Director) async throws -> UIImage {
        if let image = director.image {
            return image
        }

        guard let url = URL(string: director.pictureURL) else {
            Logger.networkManager.error("Invalid URL for director: \(director.name), url: \(director.pictureURL)")
            throw NetworkError.missingURL
        }

        let request = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)

        guard let image = UIImage(data: data) else {
            Logger.networkManager.error("Invalid Image for director: \(director.name), data: \(data)")
            throw NetworkError.invalidImageFormat
        }

        director.image = image
        return image
    }

    func loadThumbnail(for actor: Cast) async throws -> UIImage {
        if let image = actor.image {
            return image
        }

        guard let url = URL(string: actor.pictureURL) else {
            Logger.networkManager.error("Invalid URL for director: \(actor.name), url: \(actor.pictureURL)")
            throw NetworkError.missingURL
        }

        let request = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)

        guard let image = UIImage(data: data) else {
            Logger.networkManager.error("Invalid Image for director: \(actor.name), data: \(data)")
            throw NetworkError.invalidImageFormat
        }

        actor.image = image
        return image
    }

}
