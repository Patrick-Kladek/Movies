//
//  PlaceholderCell.swift
//  Movies
//
//  Created by Patrick Kladek on 29.09.22.
//

import UIKit

final class PlaceholderCell: UICollectionViewCell, Reusable {

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UICollectionViewCell

    // MARK: - PlaceholderCell

}

// MARK: - Private

private extension PlaceholderCell {

    func setup() {
        self.backgroundColor = .quaternarySystemFill
    }
}
