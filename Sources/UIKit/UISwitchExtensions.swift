//
//  UISwitchExtensions.swift
//
//  Created by Max on 2023/11/18
//
//  Copyright © 2023 Max. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public extension UISwitch {
    func toggle(animated: Bool) {
        self.setOn(!self.isOn, animated: animated)
    }
}

#endif
