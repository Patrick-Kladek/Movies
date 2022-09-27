//
//  RatingView.swift
//  Movies
//
//  Created by Patrick Kladek on 27.09.22.
//

import UIKit

final class RatingView: UIStackView {

    let currentRating: Int = 0

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
        let starBackgroundColor = UIColor(named: "Low Emphasis")!
        for i in 0...5 {
            let image = UIImage(systemName: "star.fill")?.withTintColor(starBackgroundColor)

        }
    }
}
