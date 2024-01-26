//
//  FlatMapLatestTests.swift
//
//  Created by Max on 2024/1/26
//
//  Copyright © 2024 Max. All rights reserved.
//

@testable import SBExtensions
import XCTest

#if canImport(Combine)

import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
final class FlatMapLatestTests: XCTestCase {
    var cancellable: AnyCancellable!

    func testFlatMapLatest() {
        var value = ""

        var subscriptionCount = 0
        var cancelCount = 0

        var isCompleted = false

        let first = CurrentValueSubject<String, Never>("👦🏻")
        let second = CurrentValueSubject<String, Never>("🅰️")

        let subject = CurrentValueSubject<AnyPublisher<String, Never>, Never>(first.eraseToAnyPublisher())

        self.cancellable = subject
            .flatMapLatest {
                $0.handleEvents(receiveSubscription: { _ in
                    subscriptionCount += 1
                }, receiveCancel: {
                    cancelCount += 1
                })
                .eraseToAnyPublisher()
            }
            .sink(receiveCompletion: { _ in
                isCompleted = true
            }, receiveValue: {
                value.append($0)
            })

        first.send("🐱")
        second.send("🅱️")

        subject.send(second.eraseToAnyPublisher())

        first.send("🐶")
        second.send("🅰️")

        XCTAssertEqual(value, "👦🏻🐱🅱️🅰️")

        XCTAssertEqual(subscriptionCount, 2)
        XCTAssertEqual(cancelCount, 1)

        subject.send(completion: .finished)

        XCTAssertFalse(isCompleted)

        first.send(completion: .finished)

        XCTAssertFalse(isCompleted)

        second.send(completion: .finished)

        XCTAssertTrue(isCompleted)
    }
}

#endif
