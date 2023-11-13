//
//  CALayerExtensions.swift
//  SBExtensions
//
//  Created by JONO-Jsb on 2023/11/13.
//

#if canImport(QuartzCore)

import QuartzCore

#if canImport(UIKit)

import UIKit

#endif

public extension CALayer {
    var left: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            self.frame.origin.x = newValue
        }
    }

    var top: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            self.frame.origin.y = newValue
        }
    }

    var right: CGFloat {
        get {
            return self.frame.origin.x + self.frame.size.width
        }
        set {
            self.frame.origin.x = newValue - self.frame.size.width
        }
    }

    var bottom: CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.height
        }
        set {
            self.frame.origin.y = newValue - self.frame.size.height
        }
    }

    var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            self.frame.size.width = newValue
        }
    }

    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            self.frame.size.height = newValue
        }
    }

    var origin: CGPoint {
        get {
            return self.frame.origin
        }
        set {
            self.frame.origin = newValue
        }
    }

    var size: CGSize {
        get {
            return self.frame.size
        }
        set {
            self.frame.size = newValue
        }
    }

    var center: CGPoint {
        get {
            return CGPoint(x: self.frame.origin.x + self.frame.size.width / 2.0, y: self.frame.origin.y + self.frame.size.height / 2.0)
        }
        set {
            self.frame.origin.x = newValue.x - self.frame.size.width / 2.0
            self.frame.origin.y = newValue.y - self.frame.size.height / 2.0
        }
    }

    var centerX: CGFloat {
        get {
            return self.frame.origin.x + self.frame.size.width / 2.0
        }
        set {
            self.frame.origin.x = newValue - self.frame.size.width / 2.0
        }
    }

    var centerY: CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.height / 2.0
        }
        set {
            self.frame.origin.y = newValue - self.frame.size.height / 2.0
        }
    }

    #if canImport(UIKit)

    var corners: Corner {
        var corners = Corner()

        if self.maskedCorners.contains(.layerMinXMinYCorner) {
            corners.insert(.topLeft)
        }
        if self.maskedCorners.contains(.layerMaxXMinYCorner) {
            corners.insert(.topRight)
        }
        if self.maskedCorners.contains(.layerMaxXMaxYCorner) {
            corners.insert(.bottomRight)
        }
        if self.maskedCorners.contains(.layerMinXMaxYCorner) {
            corners.insert(.bottomLeft)
        }

        return corners
    }

    #endif
}

public extension CALayer {
    static func performWithoutAnimation(_ actions: @escaping () -> Void) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)

        actions()

        CATransaction.commit()
    }

    func addSublayers(_ layers: [CALayer]) {
        for layer in layers {
            self.addSublayer(layer)
        }
    }

    func removeAllSublayers() {
        for sublayer in self.sublayers ?? [] {
            sublayer.removeFromSuperlayer()
        }
    }

    #if canImport(UIKit)

    func addRoundCorners(_ corners: Corner, radius: CGFloat, clips: Bool = false) {
        CALayer.performWithoutAnimation {
            self.masksToBounds = clips
            self.cornerRadius = radius
            self.maskedCorners = corners.maskedCorners
            if #available(iOS 13.0, *) {
                self.cornerCurve = .continuous
            }
        }
    }

    func addBorder(color: UIColor?, width: CGFloat, corners: Corner?, radius: CGFloat?) {
        CALayer.performWithoutAnimation {
            if let borderLayer = self.sublayer(where: { $0.name == "com.max.SBExtensions.border.layer" }) {
                borderLayer.removeFromSuperlayer()
            }

            let roundedRect = self.bounds
            let roundingCorners = (corners ?? self.corners).roundingCorners
            let cornerRadii = CGSize(width: radius ?? self.cornerRadius, height: radius ?? self.cornerRadius)

            let borderLayer = CAShapeLayer()
            borderLayer.path = UIBezierPath(roundedRect: roundedRect, byRoundingCorners: roundingCorners, cornerRadii: cornerRadii).cgPath
            borderLayer.fillColor = UIColor.clear.cgColor
            borderLayer.strokeColor = color?.cgColor
            borderLayer.lineWidth = ceil(width * UIScreen.current.scale) / UIScreen.current.scale
            borderLayer.name = "com.max.SBExtensions.border.layer"

            self.insertSublayer(borderLayer, at: 0)
        }
    }

    func addShadow(color: UIColor?, x: CGFloat, y: CGFloat, blur: CGFloat, spread: CGFloat = 0.0, corners: Corner?, radius: CGFloat?) {
        CALayer.performWithoutAnimation {
            self.shadowColor = color?.cgColor
            self.shadowOpacity = 1.0
            self.shadowOffset = CGSize(width: x, height: y)
            self.shadowRadius = blur * 0.5

            let roundedRect = self.bounds.insetBy(dx: -spread, dy: -spread)
            let roundingCorners = (corners ?? self.corners).roundingCorners
            let cornerRadii = CGSize(width: radius ?? self.cornerRadius, height: radius ?? self.cornerRadius)

            self.shadowPath = UIBezierPath(roundedRect: roundedRect, byRoundingCorners: roundingCorners, cornerRadii: cornerRadii).cgPath
        }
    }

    #endif

    func sublayer(withName name: String?) -> CALayer? {
        return self.sublayer { $0.name == name }
    }

    func sublayer<T>(ofType type: T.Type) -> T? {
        return self.sublayer { $0 is T } as? T
    }
}

private extension CALayer {
    func sublayer(where predicate: @escaping (CALayer) throws -> Bool) rethrows -> CALayer? {
        var layers = [CALayer](arrayLiteral: self)
        var idx = 0

        repeat {
            let foundLayer = layers[idx]

            if try predicate(foundLayer) {
                return foundLayer
            }

            layers.append(contentsOf: foundLayer.sublayers ?? [])

            idx += 1
        } while idx < layers.count

        return nil
    }
}

#endif
