//
//  CGFloatExtensionsTests.swift
//  SBExtensionsTests
//
//  Created by JONO-Jsb on 2023/11/20.
//

@testable import SBExtensions
import XCTest

#if canImport(CoreGraphics)

import CoreGraphics

#if canImport(UIKit)

import UIKit

#endif

final class CGFloatExtensionsTests: XCTestCase {
    func testInt() {
        XCTAssertEqual(CGFloat(9.2).int, Int(9))
    }

    func testFloat() {
        XCTAssertEqual(CGFloat(9.3).float, Float(9.3))
    }

    func testDouble() {
        XCTAssertEqual(CGFloat(9.4).double, Double(9.4))
    }

    func testDegreesToRadians() {
        XCTAssertEqual(CGFloat(180.0).degreesToRadians, CGFloat.pi)
    }

    func testRadiansToDegrees() {
        XCTAssertEqual(CGFloat.pi.radiansToDegrees, CGFloat(180.0))
    }

    #if canImport(UIKit)

    func testFlatPoints() {
        XCTAssertEqual(CGFloat(CGFLOAT_MIN).flatPoints, CGFloat(0.0))
        XCTAssertEqual(CGFloat(2.1).flatPointsWithScale(2), CGFloat(2.5))
        XCTAssertEqual(CGFloat(2.1).flatPointsWithScale(3), CGFloat(2.333), accuracy: 0.001)
    }

    #endif
}

#endif
