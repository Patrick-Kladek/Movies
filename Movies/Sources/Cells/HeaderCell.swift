//
//  HeaderCell.swift
//  Movies
//
//  Created by Patrick Kladek on 22.09.22.
//

import UIKit

final class HeaderCell: UICollectionReusableView, Reusable {

    private let label = HeaderCell.makeLabel()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - HeaderCell

    var attributedText: NSAttributedString? {
        get { self.label.attributedText }
        set { self.label.attributedText = newValue }
    }

    var text: String? {
        get { self.label.text }
        set { self.label.text = newValue }
    }

    var textColor: UIColor {
        get { self.label.textColor }
        set { self.label.textColor = newValue }
    }

    var font: UIFont {
        get { self.label.font }
        set { self.label.font = newValue }
    }

    // MARK: - Reusable

    static var supplementaryViewOfKind: SupplementaryType? {
        return .header
    }
}

// MARK: - Private

private extension HeaderCell {

    static func makeLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        return label
    }

    func setup() {
        self.addSubview(self.label)
        NSLayoutConstraint.activate([
            self.label.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.label.topAnchor.constraint(equalTo: self.topAnchor),
            self.label.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.label.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
