//
//  UIStackViewExtensions.swift
//
//  Created by Max on 2023/11/2
//
//  Copyright © 2023 Max. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        for view in views {
            self.addArrangedSubview(view)
        }
    }

    func removeArrangedSubviews() {
        for view in self.arrangedSubviews {
            self.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }

    func swap(_ view1: UIView, _ view2: UIView, duration: TimeInterval, animated: Bool, completion: ((Bool) -> Void)? = nil) {
        func swapView(_ view1: UIView, _ view2: UIView) {
            if let view1IDx = self.arrangedSubviews.firstIndex(of: view1), let view2IDx = self.arrangedSubviews.firstIndex(of: view2) {
                self.removeArrangedSubview(view1)
                self.insertArrangedSubview(view1, at: view2IDx)

                self.removeArrangedSubview(view2)
                self.insertArrangedSubview(view2, at: view1IDx)
            }
        }

        if animated {
            UIView.animate(withDuration: duration, animations: {
                swapView(view1, view2)

                self.layoutIfNeeded()
            }, completion: completion)
        } else {
            swapView(view1, view2)
        }
    }
}

public extension UIStackView {
    convenience init(arrangedSubviews: [UIView], axis: NSLayoutConstraint.Axis, distribution: UIStackView.Distribution, alignment: UIStackView.Alignment, spacing: CGFloat) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.axis = axis
        self.distribution = distribution
        self.alignment = alignment
        self.spacing = spacing
    }
}

#endif
