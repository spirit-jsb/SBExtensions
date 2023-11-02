//
//  UIGestureRecognizerExtensions.swift
//  SBExtensions
//
//  Created by JONO-Jsb on 2023/11/2.
//

#if canImport(UIKit)

import UIKit

public extension UIGestureRecognizer {
    func removeFromView() {
        self.view?.removeGestureRecognizer(self)
    }
}

#endif
