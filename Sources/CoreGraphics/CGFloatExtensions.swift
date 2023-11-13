//
//  CGFloatExtensions.swift
//  SBExtensions
//
//  Created by JONO-Jsb on 2023/11/13.
//

#if canImport(CoreGraphics)

import CoreGraphics

#if canImport(UIKit)

import UIKit

#endif

public extension CGFloat {
    var int: Int {
        return Int(self)
    }

    var float: Float {
        return Float(self)
    }

    var double: Double {
        return Double(self)
    }

    var degreesToRadians: CGFloat {
        return CGFloat.pi * self / 180.0
    }

    var radiansToDegrees: CGFloat {
        return self * 180.0 / CGFloat.pi
    }

    #if canImport(UIKit)

    var flatPoints: CGFloat {
        let value = self == CGFLOAT_MIN ? 0.0 : self
        let scale = UIScreen.current.scale

        return ceil(value * scale) / scale
    }

    #endif
}

#endif