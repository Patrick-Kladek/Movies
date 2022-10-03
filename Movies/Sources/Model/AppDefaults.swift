//
//  AppDefaults.swift
//  Movies
//
//  Created by Patrick Kladek on 27.09.22.
//

import Foundation
import DefaultsKit


struct AppDefaults {

}

// MARK: - User Defaults Group

extension AppDefaults {

    @UserDefault(key: "bookmarked", defaultValue: [])
    static var bookmarked: [Int]
}
