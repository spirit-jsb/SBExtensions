//
//  FloatingPointExtensions.swift
//  SBExtensions
//
//  Created by JONO-Jsb on 2023/11/16.
//

#if canImport(Foundation)

import Foundation

#endif

public extension FloatingPoint {
    var degreesToRadians: Self {
        return Self.pi * self / Self(180)
    }

    var radiansToDegrees: Self {
        return self * Self(180) / Self.pi
    }
}

infix operator ±

public func ± <T: FloatingPoint>(lhs: T, rhs: T) -> (T, T) {
    return (lhs + rhs, lhs - rhs)
}

prefix operator ±

public prefix func ± <T: FloatingPoint>(number: T) -> (T, T) {
    return (number, -number)
}

prefix operator √

public prefix func √ <T: FloatingPoint>(number: T) -> T {
    return sqrt(number)
}
