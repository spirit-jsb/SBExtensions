//
//  XCTestExtensions.swift
//
//  Created by Max on 2024/1/24
//
//  Copyright © 2024 Max. All rights reserved.
//

#if canImport(XCTest)

import XCTest

#if canImport(UIKit)

import UIKit

#endif

#if canImport(UIKit)

func XCTAssertEqual(_ expression1: @autoclosure () throws -> UIColor, _ expression2: @autoclosure () throws -> UIColor, accuracy: CGFloat, _ message: @autoclosure () -> String = "", file: StaticString = #filePath, line: UInt = #line) {
    var color1: UIColor!
    XCTAssertNoThrow(color1 = try expression1(), message(), file: file, line: line)

    var color2: UIColor!
    XCTAssertNoThrow(color2 = try expression2(), message(), file: file, line: line)

    var red1: CGFloat = 0.0, green1: CGFloat = 0.0, blue1: CGFloat = 0.0, alpha1: CGFloat = 0.0
    var red2: CGFloat = 0.0, green2: CGFloat = 0.0, blue2: CGFloat = 0.0, alpha2: CGFloat = 0.0

    color1.getRed(&red1, green: &green1, blue: &blue1, alpha: &alpha1)
    color2.getRed(&red2, green: &green2, blue: &blue2, alpha: &alpha2)

    print(">>> red1 \(red1)")
    print(">>> red2 \(red2)")

    XCTAssertEqual(red1, red2, accuracy: accuracy, message(), file: file, line: line)
    XCTAssertEqual(green1, green2, accuracy: accuracy, message(), file: file, line: line)
    XCTAssertEqual(blue1, blue2, accuracy: accuracy, message(), file: file, line: line)
    XCTAssertEqual(alpha1, alpha2, accuracy: accuracy, message(), file: file, line: line)
}

#endif

#endif
