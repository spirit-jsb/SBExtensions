//
//  UIWindowExtensions.swift
//  SBExtensions
//
//  Created by JONO-Jsb on 2023/11/2.
//

#if canImport(UIKit)

import UIKit

public extension UIWindow {
    func switchRootViewController(_ rootViewController: UIViewController, withDuration duration: TimeInterval, animationOptions: UIView.AnimationOptions, animated: Bool, completion: (() -> Void)? = nil) {
        if animated {
            UIView.transition(with: self, duration: duration, options: animationOptions, animations: {
                let prevAnimationsEnabledStatus = UIView.areAnimationsEnabled

                UIView.setAnimationsEnabled(false)

                self.rootViewController = rootViewController

                UIView.setAnimationsEnabled(prevAnimationsEnabledStatus)
            }, completion: { _ in
                completion?()
            })
        } else {
            self.rootViewController = rootViewController

            completion?()
        }
    }
}

#endif
