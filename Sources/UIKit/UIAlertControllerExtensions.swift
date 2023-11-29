//
//  UIAlertControllerExtensions.swift
//
//  Created by Max on 2023/11/9
//
//  Copyright © 2023 Max. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public extension UIAlertController {
    @discardableResult
    func addAction(title: String, style: UIAlertAction.Style = .default, isEnabled: Bool = true, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        let alertAction = UIAlertAction(title: title, style: style, handler: handler)
        alertAction.isEnabled = isEnabled

        self.addAction(alertAction)

        return alertAction
    }
}

#endif
