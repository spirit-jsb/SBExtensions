//
//  WKWebViewExtensions.swift
//
//  Created by Max on 2023/11/9
//
//  Copyright © 2023 Max. All rights reserved.
//

#if canImport(WebKit)

import WebKit

public extension WKWebView {
    @discardableResult
    func loadURL(_ url: URL, cachePolicy: URLRequest.CachePolicy? = nil, timeoutInterval: TimeInterval? = nil) -> WKNavigation? {
        var request = URLRequest(url: url)
        if let cachePolicy = cachePolicy {
            request.cachePolicy = cachePolicy
        }
        if let timeoutInterval = timeoutInterval {
            request.timeoutInterval = timeoutInterval
        }

        return self.load(request)
    }

    @discardableResult
    func loadURLString(_ urlString: String, cachePolicy: URLRequest.CachePolicy? = nil, timeoutInterval: TimeInterval? = nil) -> WKNavigation? {
        guard let url = URL(string: urlString) else {
            return nil
        }

        return self.loadURL(url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
    }
}

#endif
