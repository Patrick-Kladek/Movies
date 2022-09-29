//
//  RatingCell.swift
//  Movies
//
//  Created by Patrick Kladek on 28.09.22.
//

import UIKit

final class RatingCell: UICollectionViewCell, Reusable {

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

    // MARK: - PosterCell

    func configure(with movie: Movie, dateFormatter: DateFormatter) {
        self.ratingView.currentRating = Int(floor(movie.rating))
    }
}

// MARK: - Private

private extension RatingCell {

    func makeRatingView() -> RatingView {
        let view = RatingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    func setup() {
        self.contentView.addSubview(self.ratingView)
        NSLayoutConstraint.activate([
            self.ratingView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.ratingView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.ratingView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.ratingView.widthAnchor.constraint(equalTo: self.ratingView.heightAnchor, multiplier: 5)
        ])
    }
}
