//
//  UIImageViewExtensions.swift
//
//  Created by Max on 2023/11/18
//
//  Copyright © 2023 Max. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public extension UIImageView {
    func blurWithStyle(_ style: UIBlurEffect.Style = .light) {
        self.clipsToBounds = true

        let blurEffect = UIBlurEffect(style: style)

        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        self.addSubview(blurEffectView)
    }
}

#endif
