//
//  MovieCell.swift
//  Movies
//
//  Created by Patrick Kladek on 16.09.22.
//

import UIKit

final class MovieCell: UICollectionViewCell, Reusable {

    private lazy var imageView: UIImageView = self.makeImageView()
    private lazy var titleLabel: UILabel = self.makeTitleLabel()
    private lazy var subtitleLabel: UILabel = self.makeSubtitleLabel()
    private lazy var ratingView: RatingView = self.makeRatingView()

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

    func configure(with movie: Movie) {
        self.subtitleLabel.text = movie.releaseDate
        self.titleLabel.text = movie.title
        self.ratingView.currentRating = Int(floor(movie.rating))
    }
}

// MARK: - Private

private extension MovieCell {

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
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = TextStyle.bodyTitle.font
        return label
    }

    func makeSubtitleLabel() -> UILabel {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white.withAlphaComponent(0.6)
        label.font = TextStyle.caption.font
        return label
    }

    func makeRatingView() -> RatingView {
        let view = RatingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }



    func setup() {
        self.addSubview(self.imageView)
        NSLayoutConstraint.activate([
            self.imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            self.imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 28),
            self.imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -24),
            self.imageView.heightAnchor.constraint(equalToConstant: 89),
            self.imageView.widthAnchor.constraint(equalToConstant: 60)
        ])

        self.addSubview(self.titleLabel)
        NSLayoutConstraint.activate([
            self.titleLabel.centerYAnchor.constraint(equalTo: self.imageView.centerYAnchor),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.imageView.trailingAnchor, constant: 26),
        ])

        self.addSubview(self.subtitleLabel)
        NSLayoutConstraint.activate([
            self.subtitleLabel.leadingAnchor.constraint(equalTo: self.titleLabel.leadingAnchor),
            self.subtitleLabel.bottomAnchor.constraint(equalTo: self.titleLabel.topAnchor)
        ])

        self.addSubview(self.ratingView)
        NSLayoutConstraint.activate([
            self.ratingView.leadingAnchor.constraint(equalTo: self.titleLabel.leadingAnchor),
            self.ratingView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor),
            self.ratingView.widthAnchor.constraint(equalTo: self.ratingView.heightAnchor, multiplier: 5)
        ])

        self.backgroundColor = .clear
    }
}
