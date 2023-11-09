//
//  UIAlertControllerExtensions.swift
//  SBExtensionsTests
//
//  Created by JONO-Jsb on 2023/11/9.
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
