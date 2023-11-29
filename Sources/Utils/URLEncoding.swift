//
//  URLEncoding.swift
//
//  Created by Max on 2023/11/18
//
//  Copyright © 2023 Max. All rights reserved.
//

#if canImport(Foundation)

import Foundation

struct URLEncoding {
    /// Configures how `Array` parameters are encoded.
    enum ArrayEncoding {
        /// An empty set of square brackets is appended to the key for every value. This is the default behavior.
        case brackets
        /// No brackets are appended. The key is encoded as is.
        case noBrackets
        /// Brackets containing the item index are appended. This matches the jQuery and Node.js behavior.
        case indexInBrackets
        /// Provide a custom array key encoding with the given closure.
        case custom((_ key: String, _ index: Int) -> String)

        func encode(key: String, atIndex index: Int) -> String {
            switch self {
                case .brackets:
                    return "\(key)[]"
                case .noBrackets:
                    return key
                case .indexInBrackets:
                    return "\(key)[\(index)]"
                case let .custom(encoding):
                    return encoding(key, index)
            }
        }
    }

    /// Configures how `Bool` parameters are encoded.
    enum BoolEncoding {
        /// Encode `true` as `1` and `false` as `0`. This is the default behavior.
        case numeric
        /// Encode `true` and `false` as string literals.
        case literal

        func encode(value: Bool) -> String {
            switch self {
                case .numeric:
                    return value ? "1" : "0"
                case .literal:
                    return value ? "true" : "false"
            }
        }
    }

    // MARK: Properties

    /// The encoding to use for `Array` parameters.
    let arrayEncoding: ArrayEncoding

    /// The encoding to use for `Bool` parameters.
    let boolEncoding: BoolEncoding

    // MARK: Initialization

    /// Creates an instance using the specified parameters.
    ///
    /// - Parameters:
    ///   - arrayEncoding: `ArrayEncoding` to use. `.brackets` by default.
    ///   - boolEncoding:  `BoolEncoding` to use. `.numeric` by default.
    init(arrayEncoding: ArrayEncoding = .brackets, boolEncoding: BoolEncoding = .numeric) {
        self.arrayEncoding = arrayEncoding
        self.boolEncoding = boolEncoding
    }

    /// Creates a percent-escaped, URL encoded query string components from the given key-value pair recursively.
    ///
    /// - Parameters:
    ///   - key:   Key of the query component.
    ///   - value: Value of the query component.
    ///
    /// - Returns: The percent-escaped, URL encoded query string components.
    func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
        var components: [(String, String)] = []

        switch value {
            case let dictionary as [String: Any]:
                for (nestedKey, value) in dictionary {
                    components += self.queryComponents(fromKey: "\(key)[\(nestedKey)]", value: value)
                }
            case let array as [Any]:
                for (index, value) in array.enumerated() {
                    components += self.queryComponents(fromKey: self.arrayEncoding.encode(key: key, atIndex: index), value: value)
                }
            case let number as NSNumber:
                if number.isBool {
                    components.append((self.escape(key), self.escape(self.boolEncoding.encode(value: number.boolValue))))
                } else {
                    components.append((self.escape(key), self.escape("\(number)")))
                }
            case let bool as Bool:
                components.append((self.escape(key), self.escape(self.boolEncoding.encode(value: bool))))
            default:
                components.append((self.escape(key), self.escape("\(value)")))
        }

        return components
    }

    /// Creates a percent-escaped string following RFC 3986 for a query string key or value.
    ///
    /// - Parameter string: `String` to be percent-escaped.
    ///
    /// - Returns:          The percent-escaped `String`.
    func escape(_ string: String) -> String {
        return string.addingPercentEncoding(withAllowedCharacters: .afURLQueryAllowed) ?? string
    }
}

private extension NSNumber {
    var isBool: Bool {
        // Use Obj-C type encoding to check whether the underlying type is a `Bool`, as it's guaranteed as part of
        // swift-corelibs-foundation, per [this discussion on the Swift forums](https://forums.swift.org/t/alamofire-on-linux-possible-but-not-release-ready/34553/22).
        return String(cString: objCType) == "c"
    }
}

private extension CharacterSet {
    /// Creates a CharacterSet from RFC 3986 allowed characters.
    ///
    /// RFC 3986 states that the following characters are "reserved" characters.
    ///
    /// - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
    /// - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="
    ///
    /// In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
    /// query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
    /// should be percent-escaped in the query string.
    static let afURLQueryAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        let encodableDelimiters = CharacterSet(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")

        return CharacterSet.urlQueryAllowed.subtracting(encodableDelimiters)
    }()
}

#endif
