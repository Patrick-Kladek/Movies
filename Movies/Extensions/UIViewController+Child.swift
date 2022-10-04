//
//  UIViewController+Child.swift
//  Movies
//
//  Created by Patrick Kladek on 04.10.22.
//

import UIKit

extension UIViewController {

    func add(_ child: UIViewController) {
        self.addChild(child)
        self.view.addSubview(child.view)
        child.didMove(toParent: self)
    }

    func remove() {
        // Just to be safe, we check that this view controller
        // is actually added to a parent before removing it.
        guard self.parent != nil else { return }

        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
}
