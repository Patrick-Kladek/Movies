//
//  GenreCell.swift
//  Movies
//
//  Created by Patrick Kladek on 29.09.22.
//

import UIKit

final class GenreCell: UICollectionViewCell, Reusable {

    let label: UILabel = GenreCell.makeLabel()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UICollectionViewCell

    override func layoutSubviews() {
        super.layoutSubviews()

        self.layer.cornerRadius = self.frame.height/2.0
    }

    // MARK: - PosterCell

}

// MARK: - Private

private extension GenreCell {

    static func makeLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = TextStyle.bodySecondary.font
        label.textColor = .black
        return label
    }

    func setup() {
        self.contentView.addSubview(self.label)
        NSLayoutConstraint.activate([
            self.label.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8),
            self.label.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.label.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8),
            self.label.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])

        self.backgroundColor = Asset.Colors.veryLowEmphasis.color
    }
}
