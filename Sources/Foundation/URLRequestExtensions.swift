//
//  URLRequestExtensions.swift
//
//  Created by Max on 2023/11/18
//
//  Copyright © 2023 Max. All rights reserved.
//

#if canImport(Foundation)

import Foundation

public extension URLRequest {
    var cURL: String {
        guard let url = self.url, let method = self.httpMethod else {
            return "$ curl command could not be created"
        }

        var components = ["$ curl -v"]

        components.append("-X \(method)")

        if let httpHeaders = self.allHTTPHeaderFields {
            for httpHeader in httpHeaders where httpHeader.key != "Cookie" {
                let escapedValue = httpHeader.value.replacingOccurrences(of: "\"", with: "\\\"")

                components.append("-H \"\(httpHeader.key): \(escapedValue)\"")
            }
        }

        if let httpBodyData = self.httpBody {
            let httpBody = String(decoding: httpBodyData, as: UTF8.self)

            var escapedBody = httpBody.replacingOccurrences(of: "\\\"", with: "\\\\\"")
            escapedBody = escapedBody.replacingOccurrences(of: "\"", with: "\\\"")

            components.append("-d \"\(escapedBody)\"")
        }

        components.append("\"\(url.absoluteString)\"")

        return components.joined(separator: " \\\n\t")
    }
}

#endif
