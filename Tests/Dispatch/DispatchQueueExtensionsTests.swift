//
//  DispatchQueueExtensionsTests.swift
//  SBExtensionsTests
//
//  Created by JONO-Jsb on 2023/11/9.
//

@testable import SBExtensions
import XCTest

#if canImport(Dispatch)

import Dispatch

final class DispatchQueueExtensionsTests: XCTestCase {
    func testIsMainQueue() {
        let expectation = self.expectation(description: "Test current queue is main queue")

        let group = DispatchGroup()

        DispatchQueue.main.async(group: group) {
            XCTAssertTrue(DispatchQueue.isMainQueue)
        }

        DispatchQueue.global().async(group: group) {
            XCTAssertFalse(DispatchQueue.isMainQueue)
        }

        group.notify(queue: .main) {
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 1.0)
    }

    func testIsCurrentQueue() {
        let expectation = self.expectation(description: "Test target queue is current queue")

        let group = DispatchGroup()
        let queue = DispatchQueue.global()

        DispatchQueue.main.async(group: group) {
            XCTAssertTrue(DispatchQueue.isCurrentQueue(DispatchQueue.main))
            XCTAssertFalse(DispatchQueue.isCurrentQueue(queue))
        }

        queue.async(group: group) {
            XCTAssertTrue(DispatchQueue.isCurrentQueue(queue))
        }

        group.notify(queue: .main) {
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 1.0)
    }

    func testAsyncAfter() {
        let expectation = self.expectation(description: "Test async execute after a specified time")

        let delay = TimeInterval(2.0)

        DispatchQueue.main.asyncAfter(delay: delay) {
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: delay + 1.0)
    }

    func testDebounce() {
        let expectation = self.expectation(description: "Test execute block after a specified time")

        let debounceDelay: TimeInterval = 0.05

        var value = 0

        let debounceIncrementor = DispatchQueue.main.debounce(delay: debounceDelay) {
            value += 1
        }

        for _ in 1 ... 10 {
            debounceIncrementor()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + debounceDelay) {
            expectation.fulfill()
        }

        XCTAssertEqual(value, 0)

        self.waitForExpectations(timeout: 1.0) { _ in
            XCTAssertEqual(value, 1)
        }
    }
}

#endif
