//
//  UIViewExtensions.swift
//
//  Created by Max on 2023/11/18
//
//  Copyright © 2023 Max. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public extension UIView {
    enum Angle {
        case degrees(CGFloat)
        case radians(CGFloat)

        var rotation: CGFloat {
            switch self {
                case let .degrees(degrees):
                    return degrees * CGFloat.pi / 180.0
                case let .radians(radians):
                    return radians
            }
        }
    }

    enum ShakeDirection {
        case horizontal
        case vertical
    }
}

public extension UIView {
    var left: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            self.frame.origin.x = newValue
        }
    }

    var safeAreaLeft: CGFloat {
        return self.safeAreaInsets.left
    }

    var top: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            self.frame.origin.y = newValue
        }
    }

    var safeAreaTop: CGFloat {
        return self.safeAreaInsets.top
    }

    var right: CGFloat {
        get {
            return self.frame.origin.x + self.frame.size.width
        }
        set {
            self.frame.origin.x = newValue - self.frame.size.width
        }
    }

    var safeAreaRight: CGFloat {
        return self.safeAreaInsets.right
    }

    var bottom: CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.height
        }
        set {
            self.frame.origin.y = newValue - self.frame.size.height
        }
    }

    var safeAreaBottom: CGFloat {
        return self.safeAreaInsets.bottom
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

    var centerX: CGFloat {
        get {
            return self.center.x
        }
        set {
            self.center.x = newValue
        }
    }

    var centerY: CGFloat {
        get {
            return self.center.y
        }
        set {
            self.center.y = newValue
        }
    }

    var parentViewController: UIViewController? {
        weak var nextResponder: UIResponder? = self

        repeat {
            nextResponder = nextResponder?.next

            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
        } while nextResponder != nil

        return nil
    }

    var parentContainerViewController: UIViewController? {
        var matchController = self.parentViewController

        var parentContainerViewController: UIViewController?

        if var navigationController = matchController?.navigationController {
            while let parentNavigationController = navigationController.navigationController {
                navigationController = parentNavigationController
            }

            var parentController: UIViewController = navigationController

            while let parent = parentController.parent, !(parent is UINavigationController), !(parent is UITabBarController), !(parent is UISplitViewController) {
                parentController = parent
            }

            if navigationController == parentController {
                parentContainerViewController = navigationController.topViewController
            } else {
                parentContainerViewController = parentController
            }
        } else if let tabBarController = matchController?.tabBarController {
            if let navigationController = tabBarController.selectedViewController as? UINavigationController {
                parentContainerViewController = navigationController.topViewController
            } else {
                parentContainerViewController = tabBarController.selectedViewController
            }
        } else {
            while let parent = matchController?.parent, !(parent is UINavigationController), !(parent is UITabBarController), !(parent is UISplitViewController) {
                matchController = parent
            }

            parentContainerViewController = matchController
        }

        return parentContainerViewController
    }

    var topMostViewController: UIViewController? {
        var hierarchyControllers = [UIViewController]()

        if var topController = self.window?.rootViewController {
            hierarchyControllers.append(topController)

            while let presentedController = topController.presentedViewController {
                topController = presentedController

                hierarchyControllers.append(presentedController)
            }

            var matchResponder: UIResponder? = self.parentViewController

            while let matchController = matchResponder as? UIViewController, !hierarchyControllers.contains(matchController) {
                while matchResponder != nil, !(matchResponder is UIViewController) {
                    matchResponder = matchResponder?.next
                }
            }

            return matchResponder as? UIViewController
        } else {
            return self.parentViewController
        }
    }

    var isRightToLeft: Bool {
        return self.effectiveUserInterfaceLayoutDirection == .rightToLeft
    }
}

public extension UIView {
    static func loadFromNib(named name: String, bundle: Bundle? = nil) -> UIView? {
        return UINib(nibName: name, bundle: bundle).instantiate(withOwner: nil, options: nil).first as? UIView
    }

    static func loadFromNib<T: UIView>(withClass viewClass: T.Type, bundle: Bundle? = nil) -> T? {
        return UINib(nibName: String(describing: viewClass), bundle: bundle).instantiate(withOwner: nil, options: nil).first as? T
    }

    static func loadFromNib<T: UIView & NibLoadable>() -> T? {
        return T.nib.instantiate(withOwner: nil, options: nil).first as? T
    }

    static func fixedWidthFlexibleSpace(width: CGFloat) -> UIView {
        let flexibleSpace = UIView()
        flexibleSpace.translatesAutoresizingMaskIntoConstraints = false
        flexibleSpace.widthAnchor.constraint(equalToConstant: width).isActive = true

        flexibleSpace.setContentHuggingPriority(.required, for: .horizontal)
        flexibleSpace.setContentCompressionResistancePriority(.required, for: .horizontal)

        return flexibleSpace
    }

    static func fixedHeightFlexibleSpace(height: CGFloat) -> UIView {
        let flexibleSpace = UIView()
        flexibleSpace.translatesAutoresizingMaskIntoConstraints = false
        flexibleSpace.heightAnchor.constraint(equalToConstant: height).isActive = true

        flexibleSpace.setContentHuggingPriority(.required, for: .vertical)
        flexibleSpace.setContentCompressionResistancePriority(.required, for: .vertical)

        return flexibleSpace
    }

    static func flexibleSpace() -> UIView {
        let flexibleSpace = UIView()

        return flexibleSpace
    }

    func addSubviews(_ views: [UIView]) {
        for view in views {
            self.addSubview(view)
        }
    }

    func removeAllSubviews() {
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
    }

    func addGestureRecognizers(_ gestureRecognizers: [UIGestureRecognizer]) {
        for gestureRecognizer in gestureRecognizers {
            self.addGestureRecognizer(gestureRecognizer)
        }
    }

    func removeAllGestureRecognizers() {
        for gestureRecognizer in self.gestureRecognizers ?? [] {
            self.removeGestureRecognizer(gestureRecognizer)
        }
    }

    func addRoundCorners(_ corners: Corner, radius: CGFloat, clips: Bool = false) {
        self.layer.addRoundCorners(corners, radius: radius, clips: clips)
    }

    func addBorder(color: UIColor?, width: CGFloat, corners: Corner?, radius: CGFloat?) {
        self.layer.addBorder(color: color, width: width, corners: corners, radius: radius)
    }

    func addShadow(color: UIColor?, x: CGFloat, y: CGFloat, blur: CGFloat, spread: CGFloat = 0.0, corners: Corner?, radius: CGFloat?) {
        self.layer.addShadow(color: color, x: x, y: y, blur: blur, spread: spread, corners: corners, radius: radius)
    }

    func fadeIn(duration: TimeInterval, completion: ((Bool) -> Void)? = nil) {
        if self.isHidden {
            self.isHidden = false
        }

        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1.0
        }, completion: completion)
    }

    func fadeOut(duration: TimeInterval, completion: ((Bool) -> Void)? = nil) {
        if self.isHidden {
            self.isHidden = false
        }

        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }

    func rotate(byAngle angle: Angle, duration: TimeInterval, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveLinear, animations: {
            self.transform = self.transform.rotated(by: angle.rotation)
        }, completion: completion)
    }

    func rotata(toAngle angle: Angle, duration: TimeInterval, completion: ((Bool) -> Void)? = nil) {
        let currentRotation = atan2(self.transform.b, self.transform.a)

        UIView.animate(withDuration: duration, delay: 0.0, options: .curveLinear, animations: {
            self.transform = self.transform.rotated(by: angle.rotation - currentRotation)
        }, completion: completion)
    }

    func scale(by offset: CGPoint, duration: TimeInterval, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveLinear, animations: {
            self.transform = self.transform.scaledBy(x: offset.x, y: offset.y)
        }, completion: completion)
    }

    func shake(direction: ShakeDirection, intensity: CGFloat = 0.1, duration: TimeInterval, completion: (() -> Void)? = nil) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)

        let animation: CAKeyframeAnimation
        switch direction {
            case .horizontal:
                animation = .init(keyPath: "position.x")
            case .vertical:
                animation = .init(keyPath: "position.y")
        }

        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.values = [-intensity, intensity, -intensity, intensity, 0.0]

        self.layer.add(animation, forKey: "shake")

        CATransaction.commit()
    }

    func screenshot() -> UIImage? {
        guard self.layer.frame.size != .zero else {
            return nil
        }

        return UIGraphicsImageRenderer(size: self.layer.frame.size).image { context in
            self.layer.render(in: context.cgContext)
        }
    }

    func firstResponder() -> UIView? {
        return self.subview { $0.isFirstResponder }
    }

    func subview(withTag tag: Int) -> UIView? {
        return self.subview { $0.tag == tag }
    }

    func subview<T>(ofType type: T.Type) -> T? {
        return self.subview { $0 is T } as? T
    }
}

private extension UIView {
    func subview(where predicate: @escaping (UIView) throws -> Bool) rethrows -> UIView? {
        var views = [UIView](arrayLiteral: self)
        var idx = 0

        repeat {
            let foundView = views[idx]

            if try predicate(foundView) {
                return foundView
            }

            views.append(contentsOf: foundView.subviews)

            idx += 1
        } while idx < views.count

        return nil
    }
}

#endif
