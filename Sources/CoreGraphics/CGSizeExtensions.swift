//
//  CGSizeExtensions.swift
//  SBExtensions
//
//  Created by JONO-Jsb on 2023/11/13.
//

#if canImport(CoreGraphics)

import CoreGraphics

#if canImport(UIKit)

import UIKit

#endif

public extension CGSize {
    var aspectRatio: CGFloat {
        guard self.height != 0.0 else {
            return 0.0
        }

        return self.width / self.height
    }

    var minDimension: CGFloat {
        return min(self.width, self.height)
    }

    var maxDimension: CGFloat {
        return max(self.width, self.height)
    }

    #if canImport(UIKit)

    var flatPoints: CGSize {
        return CGSize(width: self.width.flatPoints, height: self.height.flatPoints)
    }

    #endif
}

public extension CGSize {
    static func + (lhs: CGSize, rhs: CGSize) -> CGSize {
        return CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }

    static func + (lhs: CGSize, tuple: (width: CGFloat, height: CGFloat)) -> CGSize {
        return CGSize(width: lhs.width + tuple.width, height: lhs.height + tuple.height)
    }

    static func += (lhs: inout CGSize, rhs: CGSize) {
        lhs.width += rhs.width
        lhs.height += rhs.height
    }

    static func += (lhs: inout CGSize, tuple: (width: CGFloat, height: CGFloat)) {
        lhs.width += tuple.width
        lhs.height += tuple.height
    }

    static func - (lhs: CGSize, rhs: CGSize) -> CGSize {
        return CGSize(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
    }

    static func - (lhs: CGSize, tuple: (width: CGFloat, heoght: CGFloat)) -> CGSize {
        return CGSize(width: lhs.width - tuple.width, height: lhs.height - tuple.heoght)
    }

    static func -= (lhs: inout CGSize, rhs: CGSize) {
        lhs.width -= rhs.width
        lhs.height -= rhs.height
    }

    static func -= (lhs: inout CGSize, tuple: (width: CGFloat, height: CGFloat)) {
        lhs.width -= tuple.width
        lhs.height -= tuple.height
    }

    static func * (lhs: CGSize, scalar: CGFloat) -> CGSize {
        return CGSize(width: lhs.width * scalar, height: lhs.height * scalar)
    }

    static func * (scalar: CGFloat, rhs: CGSize) -> CGSize {
        return CGSize(width: scalar * rhs.width, height: scalar * rhs.height)
    }

    static func *= (lhs: inout CGSize, scalar: CGFloat) {
        lhs.width *= scalar
        lhs.height *= scalar
    }

    func aspectFit(to boundingSize: CGSize) -> CGSize {
        let minRatio = min(boundingSize.width / self.width, boundingSize.height / self.height)

        let width = self.width * minRatio
        let height = self.height * minRatio

        return CGSize(width: width, height: height)
    }

    func aspectFill(to boundingSize: CGSize) -> CGSize {
        let maxRatio = max(boundingSize.width / self.width, boundingSize.height / self.height)

        let width = min(self.width * maxRatio, boundingSize.width)
        let height = min(self.height * maxRatio, boundingSize.height)

        return CGSize(width: width, height: height)
    }
}

#endif
