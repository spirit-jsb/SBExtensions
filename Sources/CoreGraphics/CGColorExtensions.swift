//
//  CGColorExtensions.swift
//
//  Created by Max on 2023/11/18
//
//  Copyright © 2023 Max. All rights reserved.
//

#if canImport(CoreGraphics)

#if canImport(UIKit)

import UIKit

#endif

import CoreGraphics

public extension CGColor {
    #if canImport(UIKit)

    var uiColor: UIColor? {
        return UIColor(cgColor: self)
    }

    #endif
}

#endif
