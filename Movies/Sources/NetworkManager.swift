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

    func loadThumbnail(for movie: Movie, completion: @escaping (Result<UIImage?, Error>) -> Void) {
        if let image = movie.image {
            completion(.success(image))
            return
        }

        guard let url = URL(string: movie.posterURL) else {
            Logger.networkManager.error("Invalid URL for movie: \(movie.id), url: \(movie.posterURL)")
            return
        }

        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error {
                Logger.networkManager.error("Failed downloading poster with error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            if let data {
                let image = UIImage(data: data)
                movie.image = image
                completion(.success(image))
                return
            }

            Logger.networkManager.error("Unhandled case in URLSession.dataTask")
        }
        task.resume()
    }

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
}
