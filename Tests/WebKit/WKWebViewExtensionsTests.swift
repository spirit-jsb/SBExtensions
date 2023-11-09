//
//  WKWebViewExtensionsTests.swift
//  SBExtensionsTests
//
//  Created by JONO-Jsb on 2023/11/9.
//

@testable import SBExtensions
import XCTest

#if canImport(WebKit)

import WebKit

final class WKWebViewExtensionsTests: XCTestCase {
    var webView: WKWebView!

    private let timeout: TimeInterval = 10.0

    override func setUp() {
        self.webView = WKWebView()
    }

    func testLoadURL() {
        let expectation = WebViewSuccessExpectation(description: "Test load correct URL", webView: self.webView)

        let url = URL(string: "https://www.apple.com")!

        let navigation = self.webView.loadURL(url)

        XCTAssertNotNil(navigation)

        self.wait(for: [expectation], timeout: self.timeout)
    }

    func testLoadURLString() {
        let expectation = WebViewSuccessExpectation(description: "Test load correct URL string", webView: self.webView)

        let urlString = "https://www.apple.com"

        let navigation = self.webView.loadURLString(urlString)

        XCTAssertNotNil(navigation)

        self.wait(for: [expectation], timeout: self.timeout)
    }

    func testLoadInvalidURLString() {
        let invalidURLString = "invalid URL"

        let navigation = self.webView.loadURLString(invalidURLString)

        XCTAssertNil(navigation)
    }

    func testLoadDeathURLString() {
        let expectation = WebViewFailureExpectation(description: "Test load death URL string", webView: self.webView)

        let deathURLString = "https://dead-url-573489574389.com"

        let navigation = self.webView.loadURLString(deathURLString, timeoutInterval: 5.0)

        XCTAssertNotNil(navigation)

        self.wait(for: [expectation], timeout: self.timeout)
    }
}

class WebViewSuccessExpectation: XCTestExpectation, WKNavigationDelegate {
    init(description: String, webView: WKWebView) {
        super.init(description: description)

        webView.navigationDelegate = self
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.fulfill()
    }
}

class WebViewFailureExpectation: XCTestExpectation, WKNavigationDelegate {
    init(description: String, webView: WKWebView) {
        super.init(description: description)

        webView.navigationDelegate = self
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.fulfill()
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.fulfill()
    }
}

#endif
