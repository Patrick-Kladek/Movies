//
//  MoreCell.swift
//  Movies
//
//  Created by Patrick Kladek on 27.09.22.
//

import UIKit

final class MoreCell: UICollectionViewCell, Reusable {

    private lazy var button: PillButton = self.makeButton()

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

    func makeButton() -> PillButton {
        // TODO: Look into using UIButton.Configuration. Might solve the deprecated warning
        let button = PillButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.semanticContentAttribute = .forceRightToLeft
        button.setImage(Asset.Images.more.image, for: .normal)
        button.setTitle("See all", for: .normal)
        button.setTitleColor(Asset.Colors.highEmphasis.color, for: .normal)
        button.titleLabel?.font = TextStyle.button.font
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        button.imageEdgeInsets = UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 0)
        button.backgroundColor = .white

        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.9
        button.layer.shadowOffset = .init(width: 0, height: 4)
        button.layer.shadowRadius = 20

        return button
    }

    func setup() {
        self.addSubview(self.button)
        NSLayoutConstraint.activate([
            self.button.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.button.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])

//        self.backgroundColor = .quateßrnarySystemFill
    }
}
