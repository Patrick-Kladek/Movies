//
//  Dependencies.swift
//  Movies
//
//  Created by Patrick Kladek on 22.09.22.
//

import Foundation

protocol HasNetworkManager: AnyObject {
    var networkManager: NetworkManager { get }
}

protocol HasUserDefaults: AnyObject {
    var userDefaults: UserDefaults { get }
}

typealias AllDependencies = HasNetworkManager & HasUserDefaults

// MARK: - Dependencies

class GlobalDependencies: AllDependencies {

    let networkManager: NetworkManager
    let userDefaults: UserDefaults

    // MARK: - Dependencies

    init() {
        self.networkManager = NetworkManager.shared
        self.userDefaults = .standard
    }
}
