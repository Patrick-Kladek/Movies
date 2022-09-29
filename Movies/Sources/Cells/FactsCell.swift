//
//  FactsCell.swift
//  Movies
//
//  Created by Patrick Kladek on 29.09.22.
//

import UIKit

final class FactsCell: UICollectionViewCell, Reusable {

    private lazy var stackView: UIStackView = self.makeStackView()
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

    // MARK: - PosterCell

    func configure(with movie: Movie, dateFormatter: DateFormatter, yearFormatter: DateFormatter, timeFormatter: DateComponentsFormatter) {
        self.ratingView.currentRating = Int(floor(movie.rating))

        let dateString = dateFormatter.string(from: movie.releaseDate)
        let timeString = timeFormatter.string(from: Double(movie.runtime * 60))!
        self.subtitleLabel.text = "\(dateString )  ·  \(timeString)"


        let titleAttributedString = NSMutableAttributedString(string: movie.title, attributes: [
            .font: TextStyle.title.font,
            .foregroundColor: Asset.Colors.background.color
        ])
        let yearAttributedString = NSAttributedString(string: yearFormatter.string(from: movie.releaseDate), attributes: [
            .font: TextStyle.titleSecondary.font,
            .foregroundColor: Asset.Colors.mediumEmphasis.color
        ])

        titleAttributedString.append(.init(string: " "))
        titleAttributedString.append(yearAttributedString)
        self.titleLabel.attributedText = titleAttributedString
    }
}

// MARK: - Private

private extension FactsCell {

    func makeStackView() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [self.ratingView, self.subtitleLabel, self.titleLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }

    func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 3
        label.textAlignment = .center
        return label
    }

    func makeSubtitleLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .black.withAlphaComponent(0.6)
        label.font = TextStyle.bodySecondary.font
        return label
    }

    func makeRatingView() -> RatingView {
        let view = RatingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    func setup() {
        self.contentView.addSubview(self.stackView)
        NSLayoutConstraint.activate([
            self.stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }
}
