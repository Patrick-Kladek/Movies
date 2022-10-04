//
//  MoreCell.swift
//  Movies
//
//  Created by Patrick Kladek on 27.09.22.
//

import UIKit

final class MoreCell: UICollectionViewCell, Reusable {

    private lazy var pill: UIView = self.makePill()
    private lazy var stackView: UIStackView = self.makeStackView()
    private lazy var imageView: UIImageView = self.makeImageView()
    private lazy var label: UILabel = self.makeLabel()

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

    func makePill() -> UIView {
        let view = PillButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.9
        view.layer.shadowOffset = .init(width: 0, height: 4)
        view.layer.shadowRadius = 20
        return view
    }

    func makeStackView() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [self.label, self.imageView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 6
        return stackView
    }

    func makeImageView() -> UIImageView {
        let imageView = UIImageView(image: Asset.Images.more.image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }

    func makeLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = TextStyle.button.font
        label.textColor = Asset.Colors.highEmphasis.color
        label.text = "See all"
        return label
    }

    func setup() {
        self.pill.addSubview(self.stackView)
        NSLayoutConstraint.activate([
            self.stackView.leadingAnchor.constraint(equalTo: self.pill.leadingAnchor, constant: 12),
            self.stackView.topAnchor.constraint(equalTo: self.pill.topAnchor, constant: 8),
            self.stackView.trailingAnchor.constraint(equalTo: self.pill.trailingAnchor, constant: -12),
            self.stackView.bottomAnchor.constraint(equalTo: self.pill.bottomAnchor, constant: -8)
        ])

        self.contentView.addSubview(self.pill)
        NSLayoutConstraint.activate([
            self.pill.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.pill.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])

        self.pill.isUserInteractionEnabled = false
    }
}
