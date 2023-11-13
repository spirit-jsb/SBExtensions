//
//  CGPointExtensions.swift
//  SBExtensions
//
//  Created by JONO-Jsb on 2023/11/13.
//

#if canImport(CoreGraphics)

import CoreGraphics

#if canImport(UIKit)

import UIKit

#endif

public extension CGPoint {
    #if canImport(UIKit)

    var flatPoints: CGPoint {
        return CGPoint(x: self.x.flatPoints, y: self.y.flatPoints)
    }

    #endif
}

public extension CGPoint {
    static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    static func += (lhs: inout CGPoint, rhs: CGPoint) {
        lhs.x += rhs.x
        lhs.y += rhs.y
    }

    static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

    static func -= (lhs: inout CGPoint, rhs: CGPoint) {
        lhs.x -= rhs.x
        lhs.y -= rhs.y
    }

    static func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
        return CGPoint(x: point.x * scalar, y: point.y * scalar)
    }

    static func * (scalar: CGFloat, point: CGPoint) -> CGPoint {
        return CGPoint(x: point.x * scalar, y: point.y * scalar)
    }

    static func *= (point: inout CGPoint, scalar: CGFloat) {
        point.x *= scalar
        point.y *= scalar
    }

    static func distance(from point1: CGPoint, to point2: CGPoint) -> CGFloat {
        return sqrt(pow(point2.x - point1.x, 2.0) + pow(point2.y - point1.y, 2.0))
    }

    func distance(to point: CGPoint) -> CGFloat {
        return CGPoint.distance(from: self, to: point)
    }
}

#endif