//
//  RatingCell.swift
//  Movies
//
//  Created by Patrick Kladek on 04.10.22.
//

import UIKit

final class RatingCell: UICollectionViewCell, Reusable {

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

    override func layoutSubviews() {
        super.layoutSubviews()

        self.layer.cornerRadius = self.frame.height/2.0
    }

    override var isSelected: Bool {
        didSet {
            self.stackView.arrangedSubviews.forEach { $0.tintColor = self.isSelected ? Asset.Colors.gold.color : .white }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        self.stackView.arrangedSubviews.forEach { self.stackView.removeArrangedSubview($0) }
    }

    // MAKR: - RatingCell

    func configure(with stars: Int) {
        for _ in 1...stars {
            let image = UIImage(systemName: "star.fill")
            let imageView = UIImageView(image: image)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = .white
            NSLayoutConstraint.activate([
                imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
                imageView.heightAnchor.constraint(equalToConstant: 12)
            ])

            self.stackView.addArrangedSubview(imageView)
        }
    }
}

// MARK: - Private

private extension RatingCell {

    func makeStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 2
        return stackView
    }

    func setup() {
        self.contentView.addSubview(self.stackView)
        NSLayoutConstraint.activate([
            self.stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            self.stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            self.stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            self.stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5)
        ])

        self.backgroundColor = .clear
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1.0
    }
}
