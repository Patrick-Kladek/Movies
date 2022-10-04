//
//  Array+Unique.swift
//  Movies
//
//  Created by Patrick Kladek on 04.10.22.
//

import Foundation

extension Sequence where Element: Hashable {

    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}

extension Array where Element: Equatable {

    func removeDuplicates() -> [Element] {
        var result = [Element]()

        for value in self where result.contains(value) == false {
            result.append(value)
        }

        return result
    }
}

extension Movie: Hashable {

    static func == (lhs: Movie, rhs: Movie) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}
