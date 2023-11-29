//
//  Cornered.swift
//
//  Created by Max on 2023/11/18
//
//  Copyright © 2023 Max. All rights reserved.
//

#if canImport(QuartzCore)

import QuartzCore

#if canImport(UIKit)

import UIKit

#endif

public struct Corner: OptionSet {
    public static let allCorners = Corner(rawValue: ~0)
    public static let topLeft = Corner(rawValue: 1 << 0)
    public static let topRight = Corner(rawValue: 1 << 1)
    public static let bottomLeft = Corner(rawValue: 1 << 2)
    public static let bottomRight = Corner(rawValue: 1 << 3)

    var maskedCorners: CACornerMask {
        var maskedCorners = CACornerMask()

        if self.contains(.allCorners) {
            maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        } else {
            if self.contains(.topLeft) {
                maskedCorners.insert(.layerMinXMinYCorner)
            }
            if self.contains(.topRight) {
                maskedCorners.insert(.layerMaxXMinYCorner)
            }
            if self.contains(.bottomRight) {
                maskedCorners.insert(.layerMaxXMaxYCorner)
            }
            if self.contains(.bottomLeft) {
                maskedCorners.insert(.layerMinXMaxYCorner)
            }
        }

        return maskedCorners
    }

    #if canImport(UIKit)

    var roundingCorners: UIRectCorner {
        var roundingCorners = UIRectCorner()

        if self.contains(.allCorners) {
            roundingCorners = [.allCorners]
        } else {
            if self.contains(.topLeft) {
                roundingCorners.insert(.topLeft)
            }
            if self.contains(.topRight) {
                roundingCorners.insert(.topRight)
            }
            if self.contains(.bottomRight) {
                roundingCorners.insert(.bottomRight)
            }
            if self.contains(.bottomLeft) {
                roundingCorners.insert(.bottomLeft)
            }
        }

        return roundingCorners
    }

    #endif

    public var rawValue: UInt

    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
}

#endif
