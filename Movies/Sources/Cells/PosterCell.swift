//
//  PosterCell.swift
//  Movies
//
//  Created by Patrick Kladek on 22.09.22.
//

import UIKit

final class PosterCell: UICollectionViewCell, Reusable {

    private lazy var imageView: UIImageView = self.makeImageView()

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
}

// MARK: - Private

private extension PosterCell {

    func makeImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 14
        return imageView
    }

    func setup() {
        self.contentView.addSubview(self.imageView)
        NSLayoutConstraint.activate([
            self.imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])

        self.layer.cornerRadius = 14
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5      // figma design uses 16% but it looks off
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 50

        self.backgroundColor = .quaternarySystemFill
    }
}
