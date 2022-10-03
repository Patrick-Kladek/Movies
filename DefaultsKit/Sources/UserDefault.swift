//
//  UserDefault.swift
//  DefaultsKit
//
//  Created by Patrick Kladek on 03.10.22.
//

import Foundation
import Combine

@propertyWrapper
public struct UserDefault<Value> {

    private let publisher = PassthroughSubject<Value, Never>()

    public let key: Key
    public let defaultValue: Value
    public let container: UserDefaults

    // MARK: - Lifecycle

    public init(key: Key, defaultValue: Value, container: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.container = container
    }

    // MARK: - PropertyWrapper

    public var wrappedValue: Value {
        get {
            guard let anyValue = self.container.object(forKey: self.key.rawValue) else { return self.defaultValue }
            guard let value = anyValue as? Value else { return self.defaultValue }

            return value
        }

        set {
            // Check whether we're dealing with an optional and remove the object if the new value is nil.
            if let optional = newValue as? AnyOptional, optional.isNil {
                self.container.removeObject(forKey: self.key.rawValue)
            } else {
                self.container.set(newValue, forKey: self.key.rawValue)
            }
            self.publisher.send(newValue)
        }
    }

    public var projectedValue: AnyPublisher<Value, Never> {
        return self.publisher.eraseToAnyPublisher()
    }
}

// MARK: - ExpressibleByNilLiteral

public extension UserDefault where Value: ExpressibleByNilLiteral {

    /// Creates a new User Defaults property wrapper for the given key.
    /// - Parameters:
    ///   - key: The key to use with the user defaults store.
    init(key: Key, _ container: UserDefaults = .standard) {
        self.init(key: key, defaultValue: nil, container: container)
    }
}
