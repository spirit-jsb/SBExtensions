//
//  UIButtonExtensionsTests.swift
//
//  Created by Max on 2024/1/24
//
//  Copyright © 2024 Max. All rights reserved.
//

@testable import SBExtensions
import XCTest

#if canImport(UIKit)

final class UIButtonExtensionsTests: XCTestCase {
    func testEnlargedTouchArea() {
        let button = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0))

        button.enlargedTouchArea = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)

        XCTAssertTrue(button.point(inside: CGPoint(x: 50.0, y: 50.0), with: nil))
        XCTAssertFalse(button.point(inside: CGPoint(x: 10.0, y: 10.0), with: nil))
        XCTAssertFalse(button.point(inside: CGPoint(x: 90.0, y: 90.0), with: nil))
    }

    func testSetTitleForAllStates() {
        let button = UIButton()
        let title = "Title"

        button.setTitleForAllStates(title)

        XCTAssertEqual(button.title(for: .normal), title)
        XCTAssertEqual(button.title(for: .highlighted), title)
        XCTAssertEqual(button.title(for: .selected), title)
        XCTAssertEqual(button.title(for: .disabled), title)
        XCTAssertEqual(button.title(for: .focused), title)
    }

    func testSetTitleColorForAllStates() {
        let button = UIButton()
        let titleColor = UIColor.red

        button.setTitleColorForAllStates(titleColor)

        XCTAssertEqual(button.titleColor(for: .normal), titleColor)
        XCTAssertEqual(button.titleColor(for: .highlighted), titleColor)
        XCTAssertEqual(button.titleColor(for: .selected), titleColor)
        XCTAssertEqual(button.titleColor(for: .disabled), titleColor)
        XCTAssertEqual(button.titleColor(for: .focused), titleColor)
    }

    func testSetImageForAllStates() {
        let button = UIButton()
        let image = UIImage()

        button.setImageForAllStates(image)

        XCTAssertEqual(button.image(for: .normal), image)
        XCTAssertEqual(button.image(for: .highlighted), image)
        XCTAssertEqual(button.image(for: .selected), image)
        XCTAssertEqual(button.image(for: .disabled), image)
        XCTAssertEqual(button.image(for: .focused), image)
    }

    func testSetBackgroundImageForAllStates() {
        let button = UIButton()
        let backgroundImage = UIImage()

        button.setBackgroundImageForAllStates(backgroundImage)

        XCTAssertEqual(button.backgroundImage(for: .normal), backgroundImage)
        XCTAssertEqual(button.backgroundImage(for: .highlighted), backgroundImage)
        XCTAssertEqual(button.backgroundImage(for: .selected), backgroundImage)
        XCTAssertEqual(button.backgroundImage(for: .disabled), backgroundImage)
        XCTAssertEqual(button.backgroundImage(for: .focused), backgroundImage)
    }

    func testSetAttributedTitleForAllStates() {
        let button = UIButton()
        let attributedTitle = NSAttributedString(string: "Title")

        button.setAttributedTitleForAllStates(attributedTitle)

        XCTAssertEqual(button.attributedTitle(for: .normal), attributedTitle)
        XCTAssertEqual(button.attributedTitle(for: .highlighted), attributedTitle)
        XCTAssertEqual(button.attributedTitle(for: .selected), attributedTitle)
        XCTAssertEqual(button.attributedTitle(for: .disabled), attributedTitle)
        XCTAssertEqual(button.attributedTitle(for: .focused), attributedTitle)
    }

    func testSetBackgroundColorForAllStates() {
        let button = UIButton()
        let backgroundColor = UIColor.red

        button.setBackgroundColorForAllStates(backgroundColor)

        XCTAssertEqual(button.backgroundImage(for: .normal)!.averageColor()!, backgroundColor, accuracy: 0.01)
        XCTAssertEqual(button.backgroundImage(for: .highlighted)!.averageColor()!, backgroundColor, accuracy: 0.01)
        XCTAssertEqual(button.backgroundImage(for: .selected)!.averageColor()!, backgroundColor, accuracy: 0.01)
        XCTAssertEqual(button.backgroundImage(for: .disabled)!.averageColor()!, backgroundColor, accuracy: 0.01)
        XCTAssertEqual(button.backgroundImage(for: .focused)!.averageColor()!, backgroundColor, accuracy: 0.01)
    }
}

#endif
