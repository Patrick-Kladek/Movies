//
//  RatingView.swift
//  Movies
//
//  Created by Patrick Kladek on 27.09.22.
//

import UIKit

final class RatingView: UIStackView {

    var currentRating: Int = 0 {
        didSet {
            self.update()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.update()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private

private extension RatingView {

    func update() {
        self.arrangedSubviews.forEach { self.removeArrangedSubview($0)}

        for i in 0..<5 {
            let config = UIImage.SymbolConfiguration(pointSize: 12)
            let image = UIImage(systemName: "star.fill", withConfiguration: config)
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit

            if i < self.currentRating {
                imageView.tintColor = Asset.Colors.gold.color
            } else {
                imageView.tintColor = Asset.Colors.lowEmphasis.color
            }
            self.addArrangedSubview(imageView)
        }
    }
}
