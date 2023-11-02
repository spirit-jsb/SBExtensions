//
//  UITableViewExtensions.swift
//  SBExtensions
//
//  Created by JONO-Jsb on 2023/11/2.
//

#if canImport(UIKit)

import UIKit

public extension UITableView {
    func registerCell<T: UITableViewCell>(_ cellType: T.Type) {
        self.register(cellType, forCellReuseIdentifier: cellType.identifier)
    }

    func registerCellWithNib<T: UITableViewCell & NibLoadable>(_ cellType: T.Type) {
        self.register(cellType.nib, forCellReuseIdentifier: cellType.identifier)
    }

    func registerHeaderFooterView<T: UIView>(_ viewType: T.Type) {
        self.register(viewType, forHeaderFooterViewReuseIdentifier: viewType.identifier)
    }

    func registerHeaderFooterViewWithNib<T: UIView & NibLoadable>(_ viewType: T.Type) {
        self.register(viewType.nib, forHeaderFooterViewReuseIdentifier: viewType.identifier)
    }

    func dequeueReusableCell<T: UITableViewCell>(_ cellType: T.Type) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: cellType.identifier) as? T else {
            fatalError("Could not dequeue a view of kind: UITableViewCell with identifier \(cellType.identifier) - must register a nib or a class for the identifier or connect a prototype cell in a storyboard")
        }
        return cell
    }

    func dequeueReusableCell<T: UITableViewCell>(_ cellType: T.Type, at indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: cellType.identifier, for: indexPath) as? T else {
            fatalError("Could not dequeue a view of kind: UITableViewCell with identifier \(cellType.identifier) - must register a nib or a class for the identifier or connect a prototype cell in a storyboard")
        }
        return cell
    }

    func dequeueReusableHeaderFooterView<T: UIView>(_ viewType: T.Type) -> T {
        guard let headerFooterView = self.dequeueReusableHeaderFooterView(withIdentifier: viewType.identifier) as? T else {
            fatalError("Could not dequeue a view with identifier \(viewType.identifier) - must register a nib or a class for the identifier or connect a prototype cell in a storyboard")
        }
        return headerFooterView
    }
}

private extension UIView {
    static var identifier: String {
        return String(describing: self)
    }
}

#endif
