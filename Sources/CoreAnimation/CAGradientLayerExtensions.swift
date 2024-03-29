//
//  CAGradientLayerExtensions.swift
//
//  Created by Max on 2023/11/18
//
//  Copyright © 2023 Max. All rights reserved.
//

#if canImport(QuartzCore) && canImport(UIKit)

import QuartzCore
import UIKit

public extension CAGradientLayer {
    convenience init(colors: [UIColor], locations: [CGFloat]? = nil, startPoint: CGPoint = CGPoint(x: 0.5, y: 0.0), endPoint: CGPoint = CGPoint(x: 0.5, y: 1.0), type: CAGradientLayerType = .axial) {
        self.init()
        self.colors = colors.map { $0.cgColor }
        self.locations = locations?.map { NSNumber(value: Double($0)) }
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.type = type
    }
}

#endif
