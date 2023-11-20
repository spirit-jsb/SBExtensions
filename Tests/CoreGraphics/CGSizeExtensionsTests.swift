//
//  CGSizeExtensionsTests.swift
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

final class CGSizeExtensionsTests: XCTestCase {
    let size1 = CGSize(width: 5.0, height: 5.0)
    let size2 = CGSize(width: 10.0, height: 10.0)
    
    func testAspectRatio() {
        XCTAssertEqual(CGSize(width: 10.0, height: 0.0).aspectRatio, 0.0)
        XCTAssertEqual(CGSize(width: 10.0, height: 5.0).aspectRatio, 2.0)
    }
    
    func testMinDimension() {
        XCTAssertEqual(CGSize(width: 10.0, height: 1.0).minDimension, 1.0)
    }
    
    func testMaxDimension() {
        XCTAssertEqual(CGSize(width: 1.0, height: 10.0).maxDimension, 10.0)
    }
    
    #if canImport(UIKit)
    
    func testFlatPoints() {
        XCTAssertEqual(CGSize(width: CGFloat(CGFLOAT_MIN), height: CGFloat(CGFLOAT_MIN)).flatPoints, CGSize.zero)
        XCTAssertEqual(CGSize(width: 2.1, height: 2.1).flatPointsWithScale(2).width, 2.5)
        XCTAssertEqual(CGSize(width: 2.1, height: 2.1).flatPointsWithScale(2).height, 2.5)
        XCTAssertEqual(CGSize(width: 2.1, height: 2.1).flatPointsWithScale(3).width, 2.333, accuracy: 0.001)
        XCTAssertEqual(CGSize(width: 2.1, height: 2.1).flatPointsWithScale(3).height, 2.333, accuracy: 0.001)
    }
    
    #endif
    
    func testAdd() {
        XCTAssertEqual(self.size1 + self.size2, CGSize(width: 15.0, height: 15.0))
        XCTAssertEqual(self.size1 + (20.0, 10.0), CGSize(width: 25.0, height: 15.0))
    }
    
    func testAddEqual() {
        var size = self.size1
        size += self.size2
        
        XCTAssertEqual(size, CGSize(width: 15.0, height: 15.0))
        
        size += (20.0, 10.0)
        
        XCTAssertEqual(size, CGSize(width: 35.0, height: 25.0))
    }
    
    func testSubtract() {
        XCTAssertEqual(self.size1 - self.size2, CGSize(width: -5.0, height: -5.0))
        XCTAssertEqual(self.size1 - (20.0, 10.0), CGSize(width: -15.0, height: -5.0))
    }

    func testSubtractEqual() {
        var size = self.size1
        size -= self.size2
        
        XCTAssertEqual(size, CGSize(width: -5.0, height: -5.0))
        
        size -= (20.0, 10.0)
        
        XCTAssertEqual(size, CGSize(width: -25.0, height: -15.0))
    }
    
    func testMultiply() {
        XCTAssertEqual(self.size1 * 2.0, CGSize(width: 10.0, height: 10.0))
        XCTAssertEqual(2.0 * self.size1, CGSize(width: 10.0, height: 10.0))
    }

    func testMultiplyEqual() {
        var size = self.size1
        size *= 2.0

        XCTAssertEqual(size, CGSize(width: 10.0, height: 10.0))
    }
    
    func testAspectFit() {
        XCTAssertEqual(self.size1.aspectFit(to: CGSize(width: 10.0, height: 20.0)), CGSize(width: 10.0, height: 10.0))
        XCTAssertEqual(self.size1.aspectFit(to: CGSize(width: 10.0, height: 5.0)), CGSize(width: 5.0, height: 5.0))
    }
    
    func testAspectFill() {
        XCTAssertEqual(self.size1.aspectFill(to: CGSize(width: 10.0, height: 20.0)), CGSize(width: 10.0, height: 20.0))
        XCTAssertEqual(self.size1.aspectFill(to: CGSize(width: 10.0, height: 5.0)), CGSize(width: 10.0, height: 5.0))
    }
}

#endif
