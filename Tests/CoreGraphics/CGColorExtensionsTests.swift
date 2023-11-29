//
//  CGColorExtensionsTests.swift
//
//  Created by Max on 2023/11/18
//
//  Copyright © 2023 Max. All rights reserved.
//

@testable import SBExtensions
import XCTest

#if canImport(CoreGraphics)

#if canImport(UIKit)

import UIKit

#endif

import CoreGraphics

final class CGColorExtensionsTests: XCTestCase {
    #if canImport(UIKit)

    func testUIColor() {
        let red = UIColor.red
        let cgRed = red.cgColor

        XCTAssertEqual(cgRed.uiColor, red)
    }

    #endif
}

#endif
