//
//  CGColorExtensions.swift
//  SBExtensions
//
//  Created by JONO-Jsb on 2023/11/13.
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
