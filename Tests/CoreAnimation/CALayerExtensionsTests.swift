//
//  CALayerExtensionsTests.swift
//
//  Created by Max on 2024/1/24
//
//  Copyright © 2024 Max. All rights reserved.
//

@testable import SBExtensions
import XCTest

#if canImport(QuartzCore)

import QuartzCore

#if canImport(UIKit)

import UIKit

#endif

final class CALayerExtensionsTests: XCTestCase {
    func testLeft() {
        let frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
        let layer = CALayer()
        layer.frame = frame

        XCTAssertEqual(layer.left, 0.0)

        layer.left = 10.0

        XCTAssertEqual(layer.frame.origin.x, 10.0)
    }

    func testTop() {
        let frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
        let layer = CALayer()
        layer.frame = frame

        XCTAssertEqual(layer.top, 0.0)

        layer.top = 10.0

        XCTAssertEqual(layer.frame.origin.y, 10.0)
    }

    func testRight() {
        let frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
        let layer = CALayer()
        layer.frame = frame

        XCTAssertEqual(layer.right, 100.0)

        layer.right = 10.0

        XCTAssertEqual(layer.frame.origin.x, -90.0)
    }

    func testBottom() {
        let frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
        let layer = CALayer()
        layer.frame = frame

        XCTAssertEqual(layer.bottom, 100.0)

        layer.bottom = 10.0

        XCTAssertEqual(layer.frame.origin.y, -90.0)
    }

    func testWidth() {
        let frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
        let layer = CALayer()
        layer.frame = frame

        XCTAssertEqual(layer.width, 100.0)

        layer.width = 10.0

        XCTAssertEqual(layer.frame.size.width, 10.0)
    }

    func testHeight() {
        let frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
        let layer = CALayer()
        layer.frame = frame

        XCTAssertEqual(layer.height, 100.0)

        layer.height = 10.0

        XCTAssertEqual(layer.frame.size.height, 10.0)
    }

    func testOrigin() {
        let frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
        let layer = CALayer()
        layer.frame = frame

        XCTAssertEqual(layer.origin, CGPoint.zero)

        layer.origin = CGPoint(x: 10.0, y: 10.0)

        XCTAssertEqual(layer.frame.origin.x, 10.0)
        XCTAssertEqual(layer.frame.origin.y, 10.0)
    }

    func testSize() {
        let frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
        let layer = CALayer()
        layer.frame = frame

        XCTAssertEqual(layer.size, CGSize(width: 100.0, height: 100.0))

        layer.size = CGSize(width: 10.0, height: 10.0)

        XCTAssertEqual(layer.frame.size.width, 10.0)
        XCTAssertEqual(layer.frame.size.height, 10.0)
    }

    func testCenter() {
        let frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
        let layer = CALayer()
        layer.frame = frame

        XCTAssertEqual(layer.center, CGPoint(x: 50.0, y: 50.0))

        layer.center = CGPoint(x: 10.0, y: 10.0)

        XCTAssertEqual(layer.frame.origin.x, -40.0)
        XCTAssertEqual(layer.frame.origin.y, -40.0)
    }

    func testCenterX() {
        let frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
        let layer = CALayer()
        layer.frame = frame

        XCTAssertEqual(layer.centerX, 50.0)

        layer.centerX = 10.0

        XCTAssertEqual(layer.frame.origin.x, -40.0)
    }

    func testCenterY() {
        let frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
        let layer = CALayer()
        layer.frame = frame

        XCTAssertEqual(layer.centerY, 50.0)

        layer.centerY = 10.0

        XCTAssertEqual(layer.frame.origin.y, -40.0)
    }

    #if canImport(UIKit)

    func testCorners() {
        let layer = CALayer()

        XCTAssertEqual(layer.corners, [.topLeft, .topRight, .bottomRight, .bottomLeft])

        layer.maskedCorners = .layerMinXMinYCorner

        XCTAssertEqual(layer.corners, .topLeft)

        layer.maskedCorners = .layerMaxXMinYCorner

        XCTAssertEqual(layer.corners, .topRight)

        layer.maskedCorners = .layerMaxXMaxYCorner

        XCTAssertEqual(layer.corners, .bottomRight)

        layer.maskedCorners = .layerMinXMaxYCorner

        XCTAssertEqual(layer.corners, .bottomLeft)
    }

    #endif

    func testAddSublayers() {
        let layer = CALayer()

        layer.addSublayers([CALayer(), CALayer()])

        XCTAssertEqual(layer.sublayers?.count, 2)
    }

    func testRemoveAllSublayers() {
        let frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
        let layer = CALayer()
        layer.frame = frame

        layer.addSublayer(CALayer())
        layer.addSublayer(CALayer())

        layer.removeAllSublayers()

        XCTAssertEqual(layer.sublayers?.count, nil)
    }

    #if canImport(UIKit)

    func testAddRoundCorners() {
        let frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
        let layer = CALayer()
        layer.frame = frame

        layer.addRoundCorners(.allCorners, radius: 10.0, clips: true)

        XCTAssertEqual(layer.masksToBounds, true)
        XCTAssertEqual(layer.cornerRadius, 10.0)
        XCTAssertEqual(layer.maskedCorners, [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner])
    }

    func testAddBorder() {
        let frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
        let layer = CALayer()
        layer.frame = frame

        layer.addBorder(color: UIColor.red, width: 1.0)

        XCTAssertEqual(layer.borderWidth, 1.0)
        XCTAssertEqual(layer.borderColor, UIColor.red.cgColor)
    }

    func testAddShadow() {
        let frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
        let layer = CALayer()
        layer.frame = frame

        layer.addShadow(color: UIColor.red, x: 1.0, y: 1.0, blur: 3.0, spread: 1.0, corners: .allCorners, radius: 10.0)

        XCTAssertEqual(layer.shadowColor, UIColor.red.cgColor)
        XCTAssertEqual(layer.shadowOffset, CGSize(width: 1.0, height: 1.0))
        XCTAssertEqual(layer.shadowRadius, 1.5)

        let shadowBezierPath = UIBezierPath(roundedRect: layer.bounds.insetBy(dx: -1.0, dy: -1.0), byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 10.0, height: 10.0))

        XCTAssertEqual(layer.shadowPath, shadowBezierPath.cgPath)
    }

    func testAddShadowWithoutCornerRadius() {
        let frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
        let layer = CALayer()
        layer.frame = frame

        layer.addShadow(color: UIColor.red, x: 1.0, y: 1.0, blur: 3.0, spread: 1.0, corners: nil, radius: nil)

        XCTAssertEqual(layer.shadowColor, UIColor.red.cgColor)
        XCTAssertEqual(layer.shadowOffset, CGSize(width: 1.0, height: 1.0))
        XCTAssertEqual(layer.shadowRadius, 1.5)

        let shadowBezierPath = UIBezierPath(roundedRect: layer.bounds.insetBy(dx: -1.0, dy: -1.0), byRoundingCorners: .allCorners, cornerRadii: CGSize.zero)

        XCTAssertEqual(layer.shadowPath, shadowBezierPath.cgPath)
    }

    #endif

    func testSublayerWithName() {
        let layer = CALayer()

        let shapeLayer = CAShapeLayer()
        shapeLayer.name = "shapeLayer"

        let gradientLayer = CAGradientLayer()

        layer.addSublayer(shapeLayer)
        layer.addSublayer(gradientLayer)

        XCTAssertEqual(layer.sublayer(withName: "shapeLayer"), shapeLayer)
        XCTAssertNil(layer.sublayer(withName: "gradientLayer"))
    }

    func testSublayerOfType() {
        let layer = CALayer()

        let shapeLayer = CAShapeLayer()
        shapeLayer.name = "shapeLayer"

        let gradientLayer = CAGradientLayer()

        layer.addSublayer(shapeLayer)
        layer.addSublayer(gradientLayer)

        XCTAssertEqual(layer.sublayer(ofType: CAShapeLayer.self), shapeLayer)
        XCTAssertNil(layer.sublayer(ofType: CAEmitterLayer.self))
    }
}

#endif
