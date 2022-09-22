//
//  HeaderCell.swift
//  Movies
//
//  Created by Patrick Kladek on 22.09.22.
//

import UIKit

final class HeaderCell: UICollectionReusableView, Reusable {

    private let label = UILabel()

    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - HeaderCell

    var title: String? {
        get { self.label.text}
        set { self.label.text = newValue }
    }

    // MARK: - Reusable

    static var supplementaryViewOfKind: SupplementaryType? {
        return .header
    }
}

// MARK: - Private

private extension HeaderCell {

    func setup() {
        self.backgroundColor = .red
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.label)
        NSLayoutConstraint.activate([
            self.label.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.label.topAnchor.constraint(equalTo: self.topAnchor),
            self.label.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.label.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
