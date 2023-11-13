//
//  CGRectExtensions.swift
//  SBExtensions
//
//  Created by JONO-Jsb on 2023/11/13.
//

#if canImport(CoreGraphics)

import CoreGraphics

#if canImport(UIKit)

import UIKit

#endif

public extension CGRect {
    var center: CGPoint {
        return CGPoint(x: self.midX, y: self.midY)
    }

    #if canImport(UIKit)

    var flatPoints: CGRect {
        return CGRect(origin: self.origin.flatPoints, size: self.size.flatPoints)
    }

    #endif
}

public extension CGRect {
    func resizing(to size: CGSize, anchor: CGPoint = CGPoint(x: 0.5, y: 0.5)) -> CGRect {
        let sizeDelta = CGSize(width: size.width - self.width, height: size.height - self.height)

        let origin = CGPoint(x: self.minX - sizeDelta.width * anchor.x, y: self.minY - sizeDelta.height * anchor.y)

        return CGRect(origin: origin, size: sizeDelta)
    }
}

public extension CGRect {
    init(center: CGPoint, size: CGSize) {
        let origin = CGPoint(x: center.x - size.width / 2.0, y: center.y - size.height / 2.0)

        self.init(origin: origin, size: size)
    }
}

#endif
