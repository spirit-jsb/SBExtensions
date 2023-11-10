//
//  UISwitchExtensions.swift
//  SBExtensions
//
//  Created by JONO-Jsb on 2023/11/10.
//

#if canImport(UIKit)

import UIKit

public extension UISwitch {
    func toggle(animated: Bool) {
        self.setOn(!self.isOn, animated: animated)
    }
}

#endif
