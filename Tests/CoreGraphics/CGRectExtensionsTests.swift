//
//  CGRectExtensionsTests.swift
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

final class CGRectExtensionsTests: XCTestCase {
    func testCenter() {
        XCTAssertEqual(CGRect(x: 5.0, y: 5.0, width: 10.0, height: 10.0).center, CGPoint(x: 10.0, y: 10.0))
    }

    func testInitializeWithCenter() {
        let rect = CGRect(center: CGPoint(x: 10.0, y: 20.0), size: CGSize(width: 20.0, height: 10.0))

        XCTAssertEqual(rect.origin.x, 0.0)
        XCTAssertEqual(rect.origin.y, 15.0)
        XCTAssertEqual(rect.size.width, 20.0)
        XCTAssertEqual(rect.size.height, 10.0)
    }

    func testFlatPoints() {
        XCTAssertEqual(CGRect(x: CGFloat(CGFLOAT_MIN), y: CGFloat(CGFLOAT_MIN), width: CGFloat(CGFLOAT_MIN), height: CGFloat(CGFLOAT_MIN)).flatPoints, CGRect.zero)
        XCTAssertEqual(CGRect(x: 2.1, y: 2.1, width: 2.1, height: 2.1).flatPointsWithScale(2).origin.x, 2.5)
        XCTAssertEqual(CGRect(x: 2.1, y: 2.1, width: 2.1, height: 2.1).flatPointsWithScale(2).origin.y, 2.5)
        XCTAssertEqual(CGRect(x: 2.1, y: 2.1, width: 2.1, height: 2.1).flatPointsWithScale(2).size.width, 2.5)
        XCTAssertEqual(CGRect(x: 2.1, y: 2.1, width: 2.1, height: 2.1).flatPointsWithScale(2).size.height, 2.5)
        XCTAssertEqual(CGRect(x: 2.1, y: 2.1, width: 2.1, height: 2.1).flatPointsWithScale(3).origin.x, 2.333, accuracy: 0.001)
        XCTAssertEqual(CGRect(x: 2.1, y: 2.1, width: 2.1, height: 2.1).flatPointsWithScale(3).origin.y, 2.333, accuracy: 0.001)
        XCTAssertEqual(CGRect(x: 2.1, y: 2.1, width: 2.1, height: 2.1).flatPointsWithScale(3).size.width, 2.333, accuracy: 0.001)
        XCTAssertEqual(CGRect(x: 2.1, y: 2.1, width: 2.1, height: 2.1).flatPointsWithScale(3).size.height, 2.333, accuracy: 0.001)
    }

    func testResizingWithAnchor() {
        let rect = CGRect(x: 5.0, y: 5.0, width: 10.0, height: 10.0)

        // by anchor center
        XCTAssertEqual(rect.resizing(to: CGSize(width: 15.0, height: 15.0)), CGRect(x: 2.5, y: 2.5, width: 5.0, height: 5.0))

        // by anchor top left
        XCTAssertEqual(rect.resizing(to: CGSize(width: 30.0, height: 20.0), anchor: CGPoint(x: 0.0, y: 0.0)), CGRect(x: 5.0, y: 5.0, width: 20.0, height: 10.0))

        // by anchor top right
        XCTAssertEqual(rect.resizing(to: CGSize(width: 20.0, height: 20.0), anchor: CGPoint(x: 1.0, y: 0.0)), CGRect(x: -5.0, y: 5.0, width: 10.0, height: 10.0))

        // by anchor bottom left
        XCTAssertEqual(rect.resizing(to: CGSize(width: 30.0, height: 30.0), anchor: CGPoint(x: 0.0, y: 1.0)), CGRect(x: 5.0, y: -15.0, width: 20.0, height: 20.0))

        // by anchor bottom right
        XCTAssertEqual(rect.resizing(to: CGSize(width: 20.0, height: 30.0), anchor: CGPoint(x: 1.0, y: 1.0)), CGRect(x: -5.0, y: -15.0, width: 10.0, height: 20.0))
    }
}

#endif
