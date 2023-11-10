//
//  UITableViewExtensions.swift
//  SBExtensions
//
//  Created by JONO-Jsb on 2023/11/2.
//

#if canImport(UIKit)

import UIKit

public extension UITableView {
    var lastRowIndexPath: IndexPath? {
        return self.indexPathOfLastRow(inSection: self.lastSection)
    }

    var lastSection: Int {
        return self.numberOfSections > 0 ? self.numberOfSections - 1 : 0
    }

    var numberOfRows: Int {
        var section = 0
        var rowsCount = 0

        while section < self.numberOfSections {
            rowsCount += self.numberOfRows(inSection: section)
            section += 1
        }

        return rowsCount
    }
}

public extension UITableView {
    func registerCell<T: UITableViewCell>(_ cellType: T.Type) {
        self.register(cellType, forCellReuseIdentifier: cellType.identifier)
    }

    func registerCell<T: UITableViewCell & NibLoadable>(_ nibType: T.Type) {
        self.register(nibType.nib, forCellReuseIdentifier: nibType.identifier)
    }

    func registerHeaderFooterView<T: UIView>(_ viewType: T.Type) {
        self.register(viewType, forHeaderFooterViewReuseIdentifier: viewType.identifier)
    }

    func registerHeaderFooterView<T: UIView & NibLoadable>(_ nibType: T.Type) {
        self.register(nibType.nib, forHeaderFooterViewReuseIdentifier: nibType.identifier)
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

    func removeTableHeaderView() {
        self.tableHeaderView = nil
    }

    func removeTableFooterView() {
        self.tableFooterView = nil
    }

    func indexPathOfLastRow(inSection section: Int) -> IndexPath? {
        guard section >= 0, section < self.numberOfSections else {
            return nil
        }

        let rowsCount = self.numberOfRows(inSection: section)

        return IndexPath(item: rowsCount > 0 ? rowsCount - 1 : 0, section: section)
    }

    func safeScrollToRow(at indexPath: IndexPath, at scrollPosition: UITableView.ScrollPosition, animated: Bool) {
        guard indexPath.section >= 0, indexPath.section < self.numberOfSections, indexPath.row >= 0, indexPath.row < self.numberOfRows(inSection: indexPath.section) else {
            return
        }

        self.scrollToRow(at: indexPath, at: scrollPosition, animated: animated)
    }
}

private extension UIView {
    static var identifier: String {
        return String(describing: self)
    }
}

#endif
