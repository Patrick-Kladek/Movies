//
//  PillButton.swift
//  Movies
//
//  Created by Patrick Kladek on 27.09.22.
//

import UIKit

@IBDesignable
final class PillButton: UIButton {

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.updateView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIView

    override func prepareForInterfaceBuilder() {
        self.updateView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.updateView()
    }
}

// MARK: - Private

private extension PillButton {

    var cornerRadius: CGFloat {
        return self.frame.height / 2.0
    }

    func updateView() {
        self.alpha = self.isEnabled ? 1.0 : 0.3
        self.layer.cornerRadius = self.cornerRadius
    }
}
