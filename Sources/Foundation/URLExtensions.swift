//
//  URLExtensions.swift
//
//  Created by Max on 2023/11/18
//
//  Copyright © 2023 Max. All rights reserved.
//

#if canImport(Foundation)

import Foundation

public extension URL {
    var parameters: [String: String]? {
        guard let queryItems = URLComponents(url: self, resolvingAgainstBaseURL: false)?.queryItems else {
            return nil
        }

        return Dictionary(queryItems.lazy.compactMap { $0.value != nil ? ($0.name, $0.value!) : nil }) { $1 }
    }
}

public extension URL {
    func appendingParameters(_ parameters: [String: Any]?) -> URL {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)!

        if let parameters = parameters {
            components.queryItems = (components.queryItems ?? []) + parameters.map { SBExtensions.URLEncoding().queryComponents(fromKey: $0.key, value: $0.value) }.flatMap { $0.map { URLQueryItem(name: $0.0, value: $0.1) } }
        }

        return components.url!
    }

    mutating func appendParameters(_ parameters: [String: Any]?) {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)!

        if let parameters = parameters {
            components.queryItems = (components.queryItems ?? []) + parameters.map { SBExtensions.URLEncoding().queryComponents(fromKey: $0.key, value: $0.value) }.flatMap { $0.map { URLQueryItem(name: $0.0, value: $0.1) } }
        }

        self = components.url!
    }
}

#endif
