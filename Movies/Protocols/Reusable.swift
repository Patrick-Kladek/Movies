//
//  Reusable.swift
//  Movies
//
//  Created by Patrick Kladek on 16.09.22.
//

import UIKit


public enum SupplementaryType: String {
    case header = "UICollectionElementKindSectionHeader"
    case footer = "UICollectionElementKindSectionFooter"
}


public protocol Reusable: AnyObject {
    static var reuseIdentifier: String { get }
    static var supplementaryViewOfKind: SupplementaryType? { get }
    static var nib: UINib? { get }
}


public extension Reusable {

    static var reuseIdentifier: String {
        return String.init(describing: self)
    }

    static var supplementaryViewOfKind: SupplementaryType? {
        return nil
    }

    static var nib: UINib? {
        return nil
    }
}


public extension UITableView {

    func registerReusableCell<T: UITableViewCell>(_: T.Type) where T: Reusable {
        if let nib = T.nib {
            self.register(nib, forCellReuseIdentifier: T.reuseIdentifier)
        } else {
            self.register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
        }
    }

    func dequeueReusableCell<T: UITableViewCell>(indexPath: IndexPath) -> T where T: Reusable {
        return self.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as! T // swiftlint:disable:this force_cast
    }
}


public extension UICollectionView {

    func registerReusableCell<T: UICollectionViewCell>(_: T.Type) where T: Reusable {
        if let nib = T.nib {
            self.register(nib, forCellWithReuseIdentifier: T.reuseIdentifier)
        } else {
            self.register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
        }
    }

    func registerReusableSupplementaryView<T: UICollectionReusableView>(_: T.Type) where T: Reusable {
        if let nib = T.nib {
            self.register(nib, forSupplementaryViewOfKind: T.supplementaryViewOfKind!.rawValue, withReuseIdentifier: T.reuseIdentifier)
        } else {
            self.register(T.self, forSupplementaryViewOfKind: T.supplementaryViewOfKind!.rawValue, withReuseIdentifier: T.reuseIdentifier)
        }
    }

    func dequeueReusableCell<T: UICollectionViewCell>(indexPath: IndexPath) -> T where T: Reusable {
        return self.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T // swiftlint:disable:this force_cast
    }

    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(indexPath: IndexPath) -> T where T: Reusable {
        return self.dequeueReusableSupplementaryView(ofKind: T.supplementaryViewOfKind!.rawValue,
                                                     withReuseIdentifier: T.reuseIdentifier,
                                                     for: indexPath) as! T // swiftlint:disable:this force_cast
    }
}
