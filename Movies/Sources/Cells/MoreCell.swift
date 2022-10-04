//
//  MoreCell.swift
//  Movies
//
//  Created by Patrick Kladek on 27.09.22.
//

import UIKit

final class MoreCell: UICollectionViewCell, Reusable {

    private lazy var button: UIButton = self.makeButton()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private

private extension MoreCell {

    func makeButton() -> UIButton {
        var config: UIButton.Configuration = .filled()
        config.background.backgroundColor = .white
        config.cornerStyle = .capsule
        config.attributedTitle = AttributedString("See All", attributes: .init([
            NSAttributedString.Key.font: TextStyle.button.font
        ]))
        config.baseForegroundColor = Asset.Colors.highEmphasis.color
        config.image = Asset.Images.more.image
        config.imagePadding = 6
        config.imagePlacement = .trailing
        config.buttonSize = .medium
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)

        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.isEnabled = false
        button.setTitleColor(Asset.Colors.highEmphasis.color, for: .normal)

        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.9
        button.layer.shadowOffset = .init(width: 0, height: 4)
        button.layer.shadowRadius = 20

        return button
    }

    func setup() {
        self.contentView.addSubview(self.button)
        NSLayoutConstraint.activate([
            self.button.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.button.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
    }
}
