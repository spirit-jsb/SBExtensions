//
//  UIGestureRecognizerExtensions.swift
//
//  Created by Max on 2023/11/2
//
//  Copyright © 2023 Max. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public extension UIGestureRecognizer {
    func removeFromView() {
        self.view?.removeGestureRecognizer(self)
    }
}

#endif
