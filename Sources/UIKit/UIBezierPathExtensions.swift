//
//  UIBezierPathExtensions.swift
//  SBExtensionsTests
//
//  Created by JONO-Jsb on 2023/11/9.
//

#if canImport(UIKit)

import UIKit

public extension UIBezierPath {
    convenience init(from fromPoint: CGPoint, to toPoint: CGPoint) {
        self.init()

        self.move(to: fromPoint)
        self.addLine(to: toPoint)
    }

    convenience init(points: [CGPoint]) {
        self.init()

        if !points.isEmpty {
            self.move(to: points[0])
            for point in points[1...] {
                self.addLine(to: point)
            }
        }
    }

    convenience init?(polygon points: [CGPoint]) {
        guard points.count > 2 else {
            return nil
        }

        self.init()

        self.move(to: points[0])
        for point in points[1...] {
            self.addLine(to: point)
        }
        self.close()
    }
}

#endif
