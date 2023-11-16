//
//  IntExtensions.swift
//  SBExtensions
//
//  Created by JONO-Jsb on 2023/11/16.
//

#if canImport(CoreGraphics)

import CoreGraphics

#endif

public extension Int {
    var uInt: UInt {
        return UInt(self)
    }

    var float: Float {
        return Float(self)
    }

    var double: Double {
        return Double(self)
    }

    #if canImport(CoreGraphics)

    var cgFloat: CGFloat {
        return CGFloat(self)
    }

    #endif

    var degreesToRadians: Double {
        return Double.pi * Double(self) / 180.0
    }

    var radiansToDegrees: Double {
        return Double(self) * 180.0 / Double.pi
    }
}

precedencegroup PowPrecedence { higherThan: MultiplicationPrecedence }
infix operator **: PowPrecedence

public func ** (lhs: Int, rhs: Int) -> Double {
    return pow(Double(lhs), Double(rhs))
}

infix operator ±

public func ± (lhs: Int, rhs: Int) -> (Int, Int) {
    return (lhs + rhs, lhs - rhs)
}

prefix operator ±

public prefix func ± (int: Int) -> (Int, Int) {
    return (int, -int)
}

prefix operator √

public prefix func √ (int: Int) -> Double {
    return sqrt(Double(int))
}
