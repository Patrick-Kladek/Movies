//
//  Logger.swift
//  Movies
//
//  Created by Patrick Kladek on 22.09.22.
//

import Foundation
import os.log

extension Logger {

    private static var subsystem = Bundle(for: AppDelegate.self).bundleIdentifier!

    // MARK: - Logger

    static let appDelegate = Logger(subsystem: subsystem, category: "AppDelegate")
    static let sceneDelegate = Logger(subsystem: subsystem, category: "SceneDelegate")
    static let networkManager = Logger(subsystem: subsystem, category: "NetworkManager")
    static let moviesViewController = Logger(subsystem: subsystem, category: "MoviesViewController")
}
