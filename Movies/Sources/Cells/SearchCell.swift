//
//  SearchCell.swift
//  Movies
//
//  Created by Patrick Kladek on 22.09.22.
//

import UIKit

final class SearchCell: UICollectionViewCell, Reusable {

    private lazy var imageView = self.makeImageView()

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

    func makeImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = UIColor.black.withAlphaComponent(0.6)
        imageView.image = UIImage(named: "Search")
        return imageView
    }

    func setup() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 12
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3      // figma design uses 16% but it looks off
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 30

        self.contentView.addSubview(self.imageView)
        NSLayoutConstraint.activate([
            self.imageView.heightAnchor.constraint(equalToConstant: 20),
            self.imageView.widthAnchor.constraint(equalTo: self.imageView.heightAnchor),
            self.contentView.centerXAnchor.constraint(equalTo: self.imageView.centerXAnchor),
            self.contentView.centerYAnchor.constraint(equalTo: self.imageView.centerYAnchor)
        ])
    }
}
