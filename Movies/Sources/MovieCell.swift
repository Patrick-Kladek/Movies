//
//  MovieCell.swift
//  Movies
//
//  Created by Patrick Kladek on 16.09.22.
//

import UIKit

protocol MovieCellDelegate: AnyObject {
    func movieCellBookmarkChanged(_ cell: MovieCell)
}

final class MovieCell: UICollectionViewCell, Reusable {

    private lazy var imageView: UIImageView = self.makeImageView()
    private lazy var titleLabel: UILabel = self.makeTitleLabel()
    private lazy var subtitleLabel: UILabel = self.makeSubtitleLabel()
    private lazy var ratingView: RatingView = self.makeRatingView()
    private lazy var bookmarkButton: UIButton = self.makeBookmarkButton()

    weak var delegate: MovieCellDelegate?

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

    var isFavourite: Bool {
        get { self.bookmarkButton.isSelected }
        set { self.bookmarkButton.isSelected = newValue }
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
        imageView.layer.cornerRadius = 10
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

    func makeBookmarkButton() -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(Asset.Images.bookmarkSelected.image, for: .selected)
        button.setImage(Asset.Images.bookmark.image, for: .normal)
        button.addTarget(self, action: #selector(bookmarkTapped), for: .touchUpInside)
        return button
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
            self.titleLabel.leadingAnchor.constraint(equalTo: self.imageView.trailingAnchor, constant: 26)
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

        self.addSubview(self.bookmarkButton)
        NSLayoutConstraint.activate([
            self.bookmarkButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            self.bookmarkButton.heightAnchor.constraint(equalToConstant: 19),
            self.bookmarkButton.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])

        self.backgroundColor = .clear
    }

    @objc
    func bookmarkTapped(_ button: UIButton) {
        button.isSelected.toggle()
        self.delegate?.movieCellBookmarkChanged(self)
    }
}
