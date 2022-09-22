//
//  TextStyle.swift
//  Movies
//
//  Created by Patrick Kladek on 22.09.22.
//

import UIKit

enum TextStyle {
    case title
    case titleSecondary
    case bodyTitle
    case body
    case bodySecondary
    case input
    case button
    case detail
    case detailSecondary
    case caption

    var font: UIFont {
        let defaultFont = UIFont(name: "SF Pro", size: self.defaultFontSize)!

        return defaultFont.weight(self.defaultFontWeight)
    }
}

// MARK: - Private

private extension TextStyle {

    var defaultFontSize: CGFloat {
        switch self {
        case .title: return 24
        case .titleSecondary: return 24
        case .bodyTitle: return 16
        case .body: return 16
        case .bodySecondary: return 14
        case .input: return 14
        case .button: return 14
        case .detail: return 12
        case .detailSecondary: return 12
        case .caption: return 12
        }
    }

    var defaultFontWeight: UIFont.Weight {
        switch self {
        case .title: return .heavy
        case .titleSecondary: return .thin
        case .bodyTitle: return .bold
        case .body: return .thin
        case .bodySecondary: return .thin
        case .input: return .bold
        case .button: return .heavy
        case .detail: return .bold
        case .detailSecondary: return .thin
        case .caption: return .bold
        }
    }
}
