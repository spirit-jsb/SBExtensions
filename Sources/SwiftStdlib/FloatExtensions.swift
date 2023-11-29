//
//  FloatExtensions.swift
//
//  Created by Max on 2023/11/18
//
//  Copyright © 2023 Max. All rights reserved.
//

#if canImport(CoreGraphics)

import CoreGraphics

#endif

public extension Float {
    var int: Int {
        return Int(self)
    }

    var double: Double {
        return Double(self)
    }

    #if canImport(CoreGraphics)

    var cgFloat: CGFloat {
        return CGFloat(self)
    }

    #endif
}

precedencegroup PowPrecedence { higherThan: MultiplicationPrecedence }
infix operator **: PowPrecedence

public func ** (lhs: Float, rhs: Float) -> Float {
    return pow(lhs, rhs)
}
