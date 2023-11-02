//
//  WKWebViewExtensions.swift
//  SBExtensions
//
//  Created by JONO-Jsb on 2023/11/2.
//

#if canImport(WebKit)

import WebKit

public extension WKWebView {
    @discardableResult
    func loadFromURL(_ url: URL, cachePolicy: URLRequest.CachePolicy? = nil, timeoutInterval: TimeInterval? = nil) -> WKNavigation? {
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
    func loadFromURLString(_ urlString: String, cachePolicy: URLRequest.CachePolicy? = nil, timeoutInterval: TimeInterval? = nil) -> WKNavigation? {
        guard let url = URL(string: urlString) else {
            return nil
        }

        return self.loadFromURL(url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
    }
}

#endif
