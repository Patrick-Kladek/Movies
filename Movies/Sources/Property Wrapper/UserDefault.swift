//
//  UserDefault.swift
//  Movies
//
//  Created by Patrick Kladek on 27.09.22.
//

import Foundation

@propertyWrapper
public struct UserDefault<Value> {

    public let key: String
    public let defaultValue: Value
    public var container = UserDefaults.standard

    public var wrappedValue: Value {
        get {
            guard let anyValue = self.container.object(forKey: self.key) else { return self.defaultValue }
            guard let value = anyValue as? Value else { return self.defaultValue }

            return value
        }

        set {
            // Check whether we're dealing with an optional and remove the object if the new value is nil.
            if let optional = newValue as? AnyOptional, optional.isNil {
                self.container.removeObject(forKey: self.key)
            } else {
                self.container.set(newValue, forKey: self.key)
            }
        }
    }

    public init(key: String, defaultValue: Value, container: UserDefaults = UserDefaults.standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.container = container
    }
}

// MARK: - ExpressibleByNilLiteral

public extension UserDefault where Value: ExpressibleByNilLiteral {

    /// Creates a new User Defaults property wrapper for the given key.
    /// - Parameters:
    ///   - key: The key to use with the user defaults store.
    init(key: String, _ container: UserDefaults = .standard) {
        self.init(key: key, defaultValue: nil, container: container)
    }
}
