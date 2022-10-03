//
//  Optional.swift
//  Movies
//
//  Created by Patrick Kladek on 27.09.22.
//

import Foundation

extension Optional: AnyOptional {

    public var isNil: Bool {
        return self == nil
    }
}
