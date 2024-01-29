//
//  PassthroughRelayTests.swift
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
final class PassthroughRelayTests: XCTestCase {
    var relay: PassthroughRelay<String>?

    var cancellables = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()

        self.relay = PassthroughRelay()

        self.cancellables = Set()
    }

    func testFinishOnDeinit() {
        var isCompleted = false

        self.relay?
            .sink(receiveCompletion: { _ in
                isCompleted = true
            }, receiveValue: { _ in

            })
            .store(in: &self.cancellables)

        XCTAssertFalse(isCompleted)

        self.relay = nil

        XCTAssertTrue(isCompleted)
    }

    func testNoReplay() {
        var value = ""

        self.relay?.accept("0⃣️")
        self.relay?.accept("1⃣️")
        self.relay?.accept("2⃣️")

        self.relay?
            .sink(receiveValue: {
                value.append($0)
            })
            .store(in: &self.cancellables)

        XCTAssertEqual(value, "")

        self.relay?.accept("3⃣️")

        XCTAssertEqual(value, "3⃣️")

        self.relay?.accept("4⃣️")

        XCTAssertEqual(value, "3⃣️4⃣️")

        _ = self.relay?.sink(receiveValue: {
            value = $0
        })

        XCTAssertEqual(value, "3⃣️4⃣️")
    }
}

#endif
