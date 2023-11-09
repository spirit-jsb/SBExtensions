//
//  UIBezierPathExtensionsTests.swift
//  SBExtensionsTests
//
//  Created by JONO-Jsb on 2023/11/9.
//

@testable import SBExtensions
import XCTest

#if canImport(UIKit)

final class UIBezierPathExtensionsTests: XCTestCase {
    func testInitializeWithFromTo() {
        let fromPoint = CGPoint(x: 1.0, y: 2.0)
        let toPoint = CGPoint(x: -1.0, y: 0.0)

        let path = UIBezierPath(from: fromPoint, to: toPoint)

        XCTAssertEqual(path.pointsOnLine, [fromPoint, toPoint])
    }

    func testInitializeWithPoints() {
        let emptyPath = UIBezierPath(points: [])

        XCTAssertTrue(emptyPath.pointsOnLine.isEmpty)

        let points = [
            CGPoint(x: 3.0, y: 4.0),
            CGPoint(x: 1.0, y: 2.0),
            CGPoint(x: -1.0, y: 0.0),
        ]

        let path = UIBezierPath(points: points)

        XCTAssertEqual(path.pointsOnLine, points)
    }

    func testInitializeWithPolygon() {
        let brokenPolygon = [
            CGPoint(x: 1.0, y: 2.0),
            CGPoint(x: -1.0, y: 0.0),
        ]

        let brokenPath = UIBezierPath(polygon: brokenPolygon)

        XCTAssertNil(brokenPath)

        let startPoint = CGPoint.zero
        let polygon = [
            startPoint,
            CGPoint(x: 3.0, y: 4.0),
            CGPoint(x: 1.0, y: 2.0),
            CGPoint(x: -1.0, y: 0.0),
        ]

        let path = UIBezierPath(polygon: polygon)

        XCTAssertNotNil(path)
        XCTAssertEqual(path!.pointsOnLine, polygon + [startPoint])
    }
}

private extension UIBezierPath {
    var pointsOnLine: [CGPoint] {
        var points = [CGPoint]()

        self.cgPath.applyWithBlock { pointer in
            let element = pointer.pointee

            var point = CGPoint.zero
            switch element.type {
                case .moveToPoint:
                    point = element.points[0]
                case .addLineToPoint:
                    point = element.points[0]
                default:
                    break
            }

            points.append(point)
        }

        return points
    }
}

#endif
