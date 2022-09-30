//
//  KeyFactCell.swift
//  Movies
//
//  Created by Patrick Kladek on 30.09.22.
//

import UIKit

final class KeyFactCell: UICollectionViewCell, Reusable {

    private lazy var titleLabel: UILabel = self.makeTitleLabel()
    private lazy var subtitleLabel: UILabel = self.makeSubtitleLabel()
    private lazy var stackView: UIStackView = self.makeStackView()

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

    var title: String? {
        get { self.titleLabel.text }
        set { self.titleLabel.text = newValue}
    }

    var subtitle: String? {
        get { self.subtitleLabel.text }
        set { self.subtitleLabel.text = newValue}
    }
}

// MARK: - Private

private extension KeyFactCell {

    func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = TextStyle.caption.font
        label.textColor = Asset.Colors.mediumEmphasis.color
        return label
    }

    func makeSubtitleLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = TextStyle.body.font
        label.textColor = .black
        return label
    }

    func makeStackView() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [self.titleLabel, self.subtitleLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }

    func setup() {
        self.contentView.addSubview(self.stackView)
        NSLayoutConstraint.activate([
            self.stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            self.stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 12),
            self.stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            self.stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -12)
        ])
        self.layer.cornerRadius = 12
        self.backgroundColor = Asset.Colors.veryLowEmphasis.color
    }
}
