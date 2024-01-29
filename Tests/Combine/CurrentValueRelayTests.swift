//
//  CurrentValueRelayTests.swift
//
//  Created by Max on 2024/1/29
//
//  Copyright © 2024 Max. All rights reserved.
//

@testable import SBExtensions
import XCTest

#if canImport(Combine)

import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
final class CurrentValueRelayTests: XCTestCase {
    var relay: CurrentValueRelay<String>?

    var cancellables = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()

        self.relay = CurrentValueRelay("0⃣️")

        self.cancellables = Set()
    }

    func testValue() {
        XCTAssertEqual(self.relay?.value, "0⃣️")

        self.relay?.accept("1⃣️")

        XCTAssertEqual(self.relay?.value, "1⃣️")

        self.relay?.accept("2⃣️")

        XCTAssertEqual(self.relay?.value, "2⃣️")
    }

    func testCurrentValue() {
        var value = ""

        self.relay?
            .sink(receiveValue: {
                value.append($0)
            })
            .store(in: &self.cancellables)

        XCTAssertEqual(value, "0⃣️")

        self.relay?.accept("1⃣️")

        XCTAssertEqual(value, "0⃣️1⃣️")

        _ = self.relay?.sink(receiveValue: {
            value = $0
        })

        XCTAssertEqual(value, "1⃣️")
    }

    func testFinishOnDeinit() {
        var value = ""

        var isCompleted = false

        self.relay?
            .sink(receiveCompletion: { _ in
                isCompleted = true
            }, receiveValue: {
                value.append($0)
            })
            .store(in: &self.cancellables)

        XCTAssertEqual(value, "0⃣️")

        self.relay = nil

        XCTAssertTrue(isCompleted)
    }

    func testSubscribeCurrentValueRelay() {
        var value = ""

        var isCompleted = false

        self.relay?
            .sink(receiveCompletion: { _ in
                isCompleted = true
            }, receiveValue: {
                value.append($0)
            })
            .store(in: &self.cancellables)

        ["1⃣️", "2⃣️", "3⃣️"]
            .publisher
            .subscribe(self.relay!)
            .store(in: &self.cancellables)

        XCTAssertEqual(value, "0⃣️1⃣️2⃣️3⃣️")

        XCTAssertFalse(isCompleted)

        self.relay?.accept("4⃣️")

        XCTAssertEqual(value, "0⃣️1⃣️2⃣️3⃣️4⃣️")

        XCTAssertFalse(isCompleted)
    }

    func testCurrentValueRelaySubscribeCurrentValueRelay() {
        var value = ""

        var isCompleted = false

        let inputRelay = CurrentValueRelay<String>("0⃣️")
        let outputRelay = CurrentValueRelay<String>("1⃣️")

        inputRelay
            .subscribe(outputRelay)
            .store(in: &self.cancellables)

        outputRelay
            .sink(receiveCompletion: { _ in
                isCompleted = true
            }, receiveValue: {
                value.append($0)
            })
            .store(in: &self.cancellables)

        inputRelay.accept("1⃣️")
        inputRelay.accept("2⃣️")
        inputRelay.accept("3⃣️")

        XCTAssertEqual(value, "0⃣️1⃣️2⃣️3⃣️")

        XCTAssertFalse(isCompleted)
    }

    func testPassthroughRelaySubscribeCurrentValueRelay() {
        var value = ""

        var isCompleted = false

        let inputRelay = PassthroughRelay<String>()
        let outputRelay = CurrentValueRelay<String>("1⃣️")

        inputRelay
            .subscribe(outputRelay)
            .store(in: &self.cancellables)

        outputRelay
            .sink(receiveCompletion: { _ in
                isCompleted = true
            }, receiveValue: {
                value.append($0)
            })
            .store(in: &self.cancellables)

        inputRelay.accept("1⃣️")
        inputRelay.accept("2⃣️")
        inputRelay.accept("3⃣️")

        XCTAssertEqual(value, "1⃣️1⃣️2⃣️3⃣️")

        XCTAssertFalse(isCompleted)
    }
}

#endif
