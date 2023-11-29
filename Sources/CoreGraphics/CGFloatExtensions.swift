//
//  CGFloatExtensions.swift
//
//  Created by Max on 2023/11/21
//
//  Copyright © 2023 Max. All rights reserved.
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
        return self.flatPointsWithScale()
    }

    #endif
}

extension CGFloat {
    #if canImport(UIKit)

    func flatPointsWithScale(_ scale: CGFloat = 0.0) -> CGFloat {
        let value = self == CGFLOAT_MIN ? 0.0 : self
        let scale = scale == 0.0 ? UIScreen.current.scale : scale

        return ceil(value * scale) / scale
    }

    #endif
}

#endif
