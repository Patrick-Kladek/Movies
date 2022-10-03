//
//  Key.swift
//  DefaultsKit
//
//  Created by Patrick Kladek on 03.10.22.
//

import Foundation

public struct Key: RawRepresentable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension Key: ExpressibleByStringLiteral {

    public init(stringLiteral: String) {
        rawValue = stringLiteral
    }
}
