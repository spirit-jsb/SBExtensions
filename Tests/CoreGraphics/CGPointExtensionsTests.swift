//
//  CGPointExtensionsTests.swift
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

final class CGPointExtensionsTests: XCTestCase {
    let point1 = CGPoint(x: 5.0, y: 5.0)
    let point2 = CGPoint(x: 10.0, y: 10.0)

    #if canImport(UIKit)

    func testFlatPoints() {
        XCTAssertEqual(CGPoint(x: CGFloat(CGFLOAT_MIN), y: CGFloat(CGFLOAT_MIN)).flatPoints, CGPoint.zero)
        XCTAssertEqual(CGPoint(x: 2.1, y: 2.1).flatPointsWithScale(2).x, 2.5)
        XCTAssertEqual(CGPoint(x: 2.1, y: 2.1).flatPointsWithScale(2).y, 2.5)
        XCTAssertEqual(CGPoint(x: 2.1, y: 2.1).flatPointsWithScale(3).x, 2.333, accuracy: 0.001)
        XCTAssertEqual(CGPoint(x: 2.1, y: 2.1).flatPointsWithScale(3).y, 2.333, accuracy: 0.001)
    }

    #endif

    func testAdd() {
        XCTAssertEqual(self.point1 + self.point2, CGPoint(x: 15.0, y: 15.0))
    }

    func testAddEqual() {
        var point = self.point1
        point += self.point2

        XCTAssertEqual(point, CGPoint(x: 15.0, y: 15.0))
    }

    func testSubtract() {
        XCTAssertEqual(self.point1 - self.point2, CGPoint(x: -5.0, y: -5.0))
    }

    func testSubtractEqual() {
        var point = self.point1
        point -= self.point2

        XCTAssertEqual(point, CGPoint(x: -5.0, y: -5.0))
    }

    func testMultiply() {
        XCTAssertEqual(self.point1 * 2.0, CGPoint(x: 10.0, y: 10.0))
        XCTAssertEqual(2.0 * self.point2, CGPoint(x: 20.0, y: 20.0))
    }

    func testMultiplyEqual() {
        var point = self.point1
        point *= 2.0

        XCTAssertEqual(point, CGPoint(x: 10.0, y: 10.0))
    }

    func testDistance() {
        XCTAssertEqual(CGPoint.distance(from: self.point1, to: self.point2), 7.071, accuracy: 0.001)
        XCTAssertEqual(self.point1.distance(to: self.point2), 7.071, accuracy: 0.001)
    }
}

#endif
