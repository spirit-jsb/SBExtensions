//
//  UIWindowExtensions.swift
//
//  Created by Max on 2023/11/2
//
//  Copyright © 2023 Max. All rights reserved.
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
