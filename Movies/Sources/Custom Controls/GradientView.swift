//
//  GradientView.swift
//  Movies
//
//  Created by Patrick Kladek on 29.09.22.
//

import UIKit

class GradientView: UIView {

    var colors: [UIColor] = [.white, .black] {
        didSet {
            self.update()
        }
    }

    // MARK: - Lifecycle

    init(frame: CGRect = .zero, colors: [UIColor] = []) {
        self.colors = colors
        super.init(frame: frame)
        self.update()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIView

    override open class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }
}

// MARK: - Private

private extension GradientView {

    func update() {
        guard let gradientLayer = layer as? CAGradientLayer else { return }

        gradientLayer.colors = self.colors.map { $0.cgColor }
    }
}
