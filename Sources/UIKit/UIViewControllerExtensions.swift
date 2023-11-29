//
//  UIViewControllerExtensions.swift
//
//  Created by Max on 2023/11/18
//
//  Copyright © 2023 Max. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public extension UIViewController {
    var isVisible: Bool {
        // http://stackoverflow.com/questions/2777438/how-to-tell-if-uiviewcontrollers-view-is-visible
        return self.isViewLoaded && self.view.window != nil
    }
}

public extension UIViewController {
    func addChildViewController(_ child: UIViewController, toContainerView containerView: UIView) {
        self.addChild(child)

        containerView.addSubview(child.view)

        child.didMove(toParent: self)
    }

    func removeFromParentViewController() {
        guard self.parent != nil else {
            return
        }

        self.willMove(toParent: nil)

        self.view.removeFromSuperview()

        self.removeFromParent()
    }
}

#endif
