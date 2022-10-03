//
//  UIView+InterfaceBuilder.swift
//  Movies
//
//  Created by Patrick Kladek on 03.10.22.
//

import UIKit

@IBDesignable
public class RoundedView: UIView {

    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = newValue > 0
        }
    }

    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }

    @IBInspectable
    var borderColor: UIColor? {
        get {
            guard let cgColor = self.layer.borderColor else { return nil }

            return UIColor(cgColor: cgColor)  // swiftlint:disable:this no_color_initializers
        }
        set {
            self.layer.borderColor = newValue?.cgColor
        }
    }

    @IBInspectable
    var shadowColor: UIColor? {
        get {
            guard let cgColor = self.layer.borderColor else { return nil }

            return UIColor(cgColor: cgColor)  // swiftlint:disable:this no_color_initializers
        }
        set {
            self.layer.shadowColor = newValue?.cgColor
        }
    }

    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return self.layer.shadowOffset
        }
        set {
            self.layer.shadowOffset = newValue
        }
    }

    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return self.layer.shadowRadius
        }
        set {
            self.layer.shadowRadius = newValue
        }
    }

    @IBInspectable
    var shadowOpacity: CGFloat {
        get {
            return CGFloat(self.layer.shadowOpacity * 100.0)
        }
        set {
            self.layer.shadowOpacity = Float(newValue / 100.0)
        }
    }
}
