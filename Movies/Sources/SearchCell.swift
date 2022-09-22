//
//  SearchCell.swift
//  Movies
//
//  Created by Patrick Kladek on 22.09.22.
//

import UIKit

final class SearchCell: UICollectionViewCell, Reusable {

    private let imageView = UIImageView()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private

private extension SearchCell {

    func setup() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 12
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.16
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 30

        self.imageView.tintColor = UIColor.black.withAlphaComponent(0.6)
        self.imageView.image = UIImage(named: "Search")
        self.addSubview(self.imageView)
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.imageView.heightAnchor.constraint(equalToConstant: 20),
            self.imageView.widthAnchor.constraint(equalTo: self.imageView.heightAnchor),
            self.centerXAnchor.constraint(equalTo: self.imageView.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: self.imageView.centerYAnchor)
        ])
    }
}
