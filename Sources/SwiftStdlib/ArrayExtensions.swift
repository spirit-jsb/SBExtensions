//
//  ArrayExtensions.swift
//
//  Created by Max on 2023/11/18
//
//  Copyright © 2023 Max. All rights reserved.
//

#if canImport(Foundation)

import Foundation

#endif

public extension Array {
    mutating func prepend(_ newElement: Element) {
        self.insert(newElement, at: 0)
    }

    mutating func safeSwapAt(_ from: Int, _ to: Int) {
        guard from != to else {
            return
        }
        guard self.startIndex ..< self.endIndex ~= from else {
            return
        }
        guard self.startIndex ..< self.endIndex ~= to else {
            return
        }

        self.swapAt(from, to)
    }

    mutating func sort<T: Equatable>(like orderArray: [T], keyPath: KeyPath<Element, T>) {
        self = self.sorted(like: orderArray, keyPath: keyPath)
    }

    func sorted<T: Equatable>(like orderArray: [T], keyPath: KeyPath<Element, T>) -> [Element] {
        return self.lazy.sorted { lhs, rhs in
            let lhsValue = lhs[keyPath: keyPath]
            let rhsValue = rhs[keyPath: keyPath]

            // swiftformat:disable:next acronyms
            if let lhsIdx = orderArray.firstIndex(of: lhsValue), let rhsIdx = orderArray.firstIndex(of: rhsValue) {
                // swiftformat:disable:next acronyms
                return lhsIdx < rhsIdx
            } else if orderArray.contains(lhsValue) {
                return true
            } else if orderArray.contains(rhsValue) {
                return false
            } else {
                return false
            }
        }
    }

    mutating func removeDuplicates<T: Equatable>(_ keyPath: KeyPath<Element, T>) {
        self = self.removedDuplicates(keyPath)
    }

    func removedDuplicates<T: Equatable>(_ keyPath: KeyPath<Element, T>) -> [Element] {
        return self.lazy.enumerated()
            .filter { idx, element in
                self.firstIndex { $0[keyPath: keyPath] == element[keyPath: keyPath] } == idx
            }
            .map { _, element in
                element
            }
    }

    mutating func removeDuplicates() where Element: Equatable {
        self = self.removedDuplicates()
    }

    func removedDuplicates() -> [Element] where Element: Equatable {
        return self.lazy.enumerated()
            .filter { idx, element in
                self.firstIndex { $0 == element } == idx
            }
            .map { _, element in
                element
            }
    }

    @discardableResult
    mutating func removeAll(_ element: Element) -> [Element] where Element: Equatable {
        self.removeAll(where: { $0 == element })

        return self
    }

    @discardableResult
    mutating func removeAll(_ elements: [Element]) -> [Element] where Element: Equatable {
        guard !elements.isEmpty else {
            return self
        }

        self.removeAll(where: { elements.contains($0) })

        return self
    }

    #if canImport(Foundation)

    func jsonData(prettify: Bool = true) -> Data? {
        guard JSONSerialization.isValidJSONObject(self) else {
            return nil
        }

        return try? JSONSerialization.data(withJSONObject: self, options: prettify ? .prettyPrinted : [])
    }

    #endif

    #if canImport(Foundation)

    func jsonString(prettify: Bool = true) -> String? {
        guard JSONSerialization.isValidJSONObject(self) else {
            return nil
        }

        guard let jsonData = try? JSONSerialization.data(withJSONObject: self, options: prettify ? .prettyPrinted : []) else {
            return nil
        }

        return String(data: jsonData, encoding: .utf8)
    }

    #endif
}

public extension Array {
    init(count: Int, initializer: (Int) throws -> Element) rethrows {
        try self.init(unsafeUninitializedCapacity: count) { buffer, initializedCount in
            for idx in 0 ..< initializedCount {
                try buffer.baseAddress?.advanced(by: idx).initialize(to: initializer(idx))
            }

            initializedCount = count
        }
    }
}
