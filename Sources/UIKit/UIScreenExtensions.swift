//
//  UIScreenExtensions.swift
//  SBExtensions
//
//  Created by JONO-Jsb on 2023/11/2.
//

#if canImport(UIKit)

import UIKit

public extension UIScreen {
    static var current: UIScreen {
        if #available(iOS 16.0, *), let screen = UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene }).last?.screen {
            return screen
        } else {
            return UIScreen.main
        }
    }
}

#endif
