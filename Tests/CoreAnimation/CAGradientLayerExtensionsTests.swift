//
//  CAGradientLayerExtensionsTests.swift
//  SBExtensionsTests
//
//  Created by JONO-Jsb on 2023/11/16.
//

@testable import SBExtensions
import XCTest

#if canImport(QuartzCore) && canImport(UIKit)

import QuartzCore
import UIKit

final class CAGradientLayerExtensionsTests: XCTestCase {
    func testInitializeWithGradientAttributes() {
        let colors: [UIColor] = [.red, .green, .blue]
        let locations: [CGFloat]? = [0.0, 0.5, 1.0]
        let startPoint = CGPoint(x: 0.0, y: 0.5)
        let endPoint = CGPoint(x: 1.0, y: 0.5)
        let type: CAGradientLayerType = .radial

        let gradientLayer = CAGradientLayer(
            colors: colors,
            locations: locations,
            startPoint: startPoint,
            endPoint: endPoint,
            type: type
        )

        XCTAssertEqual(gradientLayer.colors?.count, colors.count)
        XCTAssertEqual(gradientLayer.locations as? [CGFloat], locations)
        XCTAssertEqual(gradientLayer.startPoint, startPoint)
        XCTAssertEqual(gradientLayer.endPoint, endPoint)
        XCTAssertEqual(gradientLayer.type, type)
    }
}

#endif
