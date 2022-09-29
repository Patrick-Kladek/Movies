//
//  TextCell.swift
//  Movies
//
//  Created by Patrick Kladek on 29.09.22.
//

import UIKit

final class TextCell: UICollectionViewCell, Reusable {

    let label: UILabel = TextCell.makeLabel()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UICollectionViewCell

    // MARK: - PosterCell

}

// MARK: - Private

private extension TextCell {

    static func makeLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = TextStyle.body.font
        label.textColor = Asset.Colors.mediumEmphasis.color
        label.numberOfLines = 0
        return label
    }

    func setup() {
        self.contentView.addSubview(self.label)
        NSLayoutConstraint.activate([
            self.label.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.label.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.label.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.label.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }
}
