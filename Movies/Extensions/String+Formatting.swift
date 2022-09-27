//
//  String+Formatting.swift
//  Movies
//
//  Created by Patrick Kladek on 22.09.22.
//

import UIKit

extension String {

    private static let defaultMarkupFont: UIFont? = UIFont.systemFont(ofSize: 12).weight(.regular)

    func parseMarkup(defaultFont: UIFont? = String.defaultMarkupFont) -> NSAttributedString {
        let font = defaultFont ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)
        let attributedString = NSMutableAttributedString(string: self)

        attributedString.addAttributes([
            .font: font.scaled()
        ], range: attributedString.fullRange)

        for bold in self.slices(from: "*", to: "*") {
            let boldRange = (self as NSString).range(of: bold)

            attributedString.addAttributes([
                .font: font.weight(.heavy).scaled(),
                .foregroundColor: UIColor.black.cgColor
            ], range: boldRange)
        }

        attributedString.mutableString.replaceOccurrences(of: "*", with: "", options: NSString.CompareOptions.caseInsensitive, range: .init(location: 0, length: attributedString.length))

        return attributedString
    }

    func slices(from: String, to: String) -> [String] {
        let scanner = Scanner(string: self)
        var results: [String] = []

        while !scanner.isAtEnd {
            _ = scanner.scanUpToString(from)
            if scanner.scanString(from) != nil {
                let result = scanner.scanUpToString(to)
                guard let string = result else { continue }

                results.append(string as String)
                _ = scanner.scanString(to)
            }
        }
        return results
    }
}

// MARK: - NSAttributedString

extension NSAttributedString {

    var fullRange: NSRange {
        return .init(location: 0, length: self.length)
    }
}
