//
//  AnyOptional.swift
//  Trial
//
//  Created by Patrick Kladek on 12.07.22.
//  Copyright © 2022 BeeOne Gmbh. All rights reserved.
//

import Foundation

/// Allows to match for optionals with generics that are defined as non-optional.
public protocol AnyOptional {
    /// Returns `true` if `nil`, otherwise `false`.
    var isNil: Bool { get }
}
