//
//  UIAlertControllerExtensionsTests.swift
//
//  Created by Max on 2023/11/18
//
//  Copyright © 2023 Max. All rights reserved.
//

@testable import SBExtensions
import XCTest

#if canImport(UIKit)

import UIKit

final class UIAlertControllerExtensionsTests: XCTestCase {
    func testAddAction() {
        let alertController = UIAlertController(title: "Title", message: "Message", preferredStyle: .alert)

        let alertAction = alertController.addAction(title: "ActionTitle", style: .destructive, isEnabled: false, handler: nil)

        XCTAssertNotNil(alertAction)

        XCTAssertEqual(alertController.actions.count, 1)
        XCTAssertEqual(alertController.actions.first?.title, "ActionTitle")
        XCTAssertEqual(alertController.actions.first?.style, .destructive)
        XCTAssertEqual(alertController.actions.first?.isEnabled, false)
    }
}

#endif
