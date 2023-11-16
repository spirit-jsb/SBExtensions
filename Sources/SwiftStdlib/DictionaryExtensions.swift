//
//  DictionaryExtensions.swift
//  SBExtensions
//
//  Created by JONO-Jsb on 2023/11/16.
//

#if canImport(Foundation)

import Foundation

#endif

public extension Dictionary {
    subscript(path keys: [Key]) -> Any? {
        get {
            guard !keys.isEmpty else {
                return nil
            }

            var result: Any? = self

            for key in keys {
                if let element = (result as? [Key: Any])?[key] {
                    result = element
                } else {
                    return nil
                }
            }

            return result
        }
        set {
            if let key = keys.first {
                if keys.count == 1, let value = newValue as? Value {
                    self[key] = value
                }

                if var embedded = self[key] as? [Key: Any] {
                    embedded[path: Array(keys.dropFirst())] = newValue

                    self[key] = embedded as? Value
                }
            }
        }
    }
}

public extension Dictionary {
    static func + (lhs: [Key: Value], rhs: [Key: Value]) -> [Key: Value] {
        var results = lhs

        rhs.forEach {
            results[$0] = $1
        }

        return results
    }

    static func += (lhs: inout [Key: Value], rhs: [Key: Value]) {
        rhs.forEach {
            lhs[$0] = $1
        }
    }

    func hasKey(_ key: Key) -> Bool {
        return self.index(forKey: key) != nil
    }

    func mapKeysAndValues<K, V>(_ transform: ((key: Key, value: Value)) throws -> (K, V)) rethrows -> [K: V] {
        // swiftformat:disable:next hoistTry
        return [K: V](uniqueKeysWithValues: try self.map(transform))
    }

    func compactMapKeysAndValues<K, V>(_ transform: ((key: Key, value: Value)) throws -> (K, V)?) rethrows -> [K: V] {
        // swiftformat:disable:next hoistTry
        return [K: V](uniqueKeysWithValues: try self.compactMap(transform))
    }

    mutating func removeAll<S>(keys: S) where S: Sequence, S.Element == Key {
        keys.forEach {
            self.removeValue(forKey: $0)
        }
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

public extension Dictionary {
    init<S>(grouping values: S, by keyPath: KeyPath<S.Element, Key>) where Value == [S.Element], S: Sequence {
        self.init(grouping: values, by: { $0[keyPath: keyPath] })
    }
}
