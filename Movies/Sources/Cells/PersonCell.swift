//
//  PersonCell.swift
//  Movies
//
//  Created by Patrick Kladek on 29.09.22.
//

import Foundation

import UIKit

final class PersonCell: UICollectionViewCell, Reusable {

    private lazy var imageView: UIImageView = self.makeImageView()
    private lazy var titleLabel: UILabel = self.makeTitleLabel()
    private lazy var subtitleLabel: UILabel = self.makeSubtitleLabel()
    private lazy var gradientView: GradientView = self.makeGradientView()
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

    override func prepareForReuse() {
        super.prepareForReuse()

        self.imageView.image = nil
    }

    // MARK: - PosterCell

    var image: UIImage? {
        get { self.imageView.image }
        set { self.imageView.image = newValue }
    }

    var title: String? {
        get { self.titleLabel.text }
        set { self.titleLabel.text = newValue }
    }

    var subtitle: String? {
        get { self.subtitleLabel.text }
        set { self.subtitleLabel.text = newValue }
    }
}

// MARK: - Private

private extension PersonCell {

    func makeImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 14
        return imageView
    }

    func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .white
        label.font = TextStyle.detail.font
        label.numberOfLines = 2
        return label
    }

    func makeSubtitleLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.textColor = Asset.Colors.mediumEmphasis.color
        label.font = TextStyle.detailSecondary.font
        label.numberOfLines = 2
        return label
    }

    func makeGradientView() -> GradientView {
        let view = GradientView(colors: [.clear, .black])
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    func makeStackView() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [self.titleLabel, self.subtitleLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }

    func setup() {
        self.contentView.addSubview(self.imageView)
        NSLayoutConstraint.activate([
            self.imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])

        self.contentView.addSubview(self.gradientView)
        NSLayoutConstraint.activate([
            self.gradientView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.gradientView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.gradientView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.gradientView.heightAnchor.constraint(equalToConstant: 100)
        ])

        self.contentView.insertSubview(self.stackView, aboveSubview: self.gradientView)
        NSLayoutConstraint.activate([
            self.stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8),
            self.stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8),
            self.stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8)
        ])

        self.layer.cornerRadius = 12
        self.gradientView.layer.cornerRadius = 12
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowRadius = 30

        self.backgroundColor = .quaternarySystemFill
    }
}
