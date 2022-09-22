//
//  UIFont+Weight.swift
//  Movies
//
//  Created by Patrick Kladek on 22.09.22.
//

import UIKit

// from: https://spin.atomicobject.com/2018/02/02/swift-scaled-font-bold-italic/
extension UIFont {

    func bold() -> UIFont {
        return self.withTraits(traits: .traitBold)
    }

    func scaled() -> UIFont {
        return UIFontMetrics.default.scaledFont(for: self)
    }
}

// MARK: - Private

private extension UIFont {

    func withTraits(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(traits)
        return UIFont(descriptor: descriptor!, size: 0) //size 0 means keep the size as it is
    }
}
