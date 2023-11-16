//
//  CGColorExtensionsTests.swift
//  SBExtensionsTests
//
//  Created by JONO-Jsb on 2023/11/16.
//

@testable import SBExtensions
import XCTest

#if canImport(CoreGraphics)

#if canImport(UIKit)

import UIKit

#endif

import CoreGraphics

final class CGColorExtensionsTests: XCTestCase {
    #if canImport(UIKit)

    func testUIColor() {
        let red = UIColor.red
        let cgRed = red.cgColor

        XCTAssertEqual(cgRed.uiColor, red)
    }

    #endif
}

#endif
