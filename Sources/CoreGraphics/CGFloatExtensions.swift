//
//  CGFloatExtensions.swift
//  SBExtensions
//
//  Created by JONO-Jsb on 2023/11/13.
//

#if canImport(CoreGraphics)

import CoreGraphics

#if canImport(Foundation)

import Foundation

#endif

public extension CGFloat {
    var abs: CGFloat {
        return Swift.abs(self)
    }

    #if canImport(Foundation)

    var ceil: CGFloat {
        return Foundation.ceil(self)
    }

    var floor: CGFloat {
        return Foundation.floor(self)
    }

    #endif

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
}

#endif
