//
//  UICollectionViewExtensions.swift
//  SBExtensions
//
//  Created by JONO-Jsb on 2023/11/2.
//

#if canImport(UIKit)

import UIKit

public extension UICollectionView {
    enum SupplementaryViewKind {
        case header
        case footer

        var rawValue: String {
            switch self {
                case .header:
                    return UICollectionView.elementKindSectionHeader
                case .footer:
                    return UICollectionView.elementKindSectionFooter
            }
        }
    }
}

public extension UICollectionView {
    func registerCell<T: UICollectionViewCell>(_ cellType: T.Type) {
        self.register(cellType, forCellWithReuseIdentifier: cellType.identifier)
    }

    func registerCellWithNib<T: UICollectionViewCell & NibLoadable>(_ cellType: T.Type) {
        self.register(cellType.nib, forCellWithReuseIdentifier: cellType.identifier)
    }

    func registerSupplementaryView<T: UICollectionReusableView>(_ viewType: T.Type, forSupplementaryViewKind kind: SupplementaryViewKind) {
        self.register(viewType, forSupplementaryViewOfKind: kind.rawValue, withReuseIdentifier: viewType.identifier)
    }

    func registerSupplementaryViewWithNib<T: UICollectionReusableView & NibLoadable>(_ viewType: T.Type, forSupplementaryViewKind kind: SupplementaryViewKind) {
        self.register(viewType.nib, forSupplementaryViewOfKind: kind.rawValue, withReuseIdentifier: viewType.identifier)
    }

    func dequeueReusableCell<T: UICollectionViewCell>(_ cellType: T.Type, at indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: cellType.identifier, for: indexPath) as? T else {
            fatalError("Could not dequeue a view of kind: UICollectionElementKindCell with identifier \(cellType.identifier) - must register a nib or a class for the identifier or connect a prototype cell in a storyboard")
        }
        return cell
    }

    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(_ viewType: T.Type, supplementaryViewKind: SupplementaryViewKind, at indexPath: IndexPath) -> T {
        guard let supplementaryView = self.dequeueReusableSupplementaryView(ofKind: supplementaryViewKind.rawValue, withReuseIdentifier: viewType.identifier, for: indexPath) as? T else {
            fatalError("Could not dequeue a view of kind: \(supplementaryViewKind.rawValue) with identifier \(viewType.identifier) - must register a nib or a class for the identifier or connect a prototype cell in a storyboard")
        }
        return supplementaryView
    }
}

private extension UICollectionReusableView {
    static var identifier: String {
        return String(describing: self)
    }
}

#endif
