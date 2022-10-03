//
//  RatingCell.swift
//  Movies
//
//  Created by Patrick Kladek on 04.10.22.
//

import UIKit

final class RatingCell: UICollectionViewCell, Reusable {

    let label: UILabel = RatingCell.makeLabel()

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

    // MAKR: - RatingCell

    func configure(with stars: Int) {
        let fullString = NSMutableAttributedString(string: "")

        for i in (0...5).reversed() where i - stars > 0 {
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = UIImage(systemName: "star.fill")?.withTintColor(.white)
            fullString.append(NSAttributedString(attachment: imageAttachment))
        }

        self.label.attributedText = fullString
    }
}

// MARK: - Private

private extension RatingCell {

    static func makeLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.systemFont(ofSize: 5)
        label.textColor = .black
        return label
    }

    func setup() {
        self.contentView.addSubview(self.label)
        NSLayoutConstraint.activate([
            self.label.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            self.label.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            self.label.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            self.label.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5)
        ])

        self.backgroundColor = .clear
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1.0
    }
}
