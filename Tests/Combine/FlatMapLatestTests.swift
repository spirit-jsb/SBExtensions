//
//  FlatMapLatestTests.swift
//  SBExtensionsTests
//
//  Created by 菅思博 on 2024/1/25.
//

@testable import SBExtensions
import XCTest

#if canImport(Combine)

import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
final class FlatMapLatestTests: XCTestCase {
    var subscription: AnyCancellable!
    
    func testFlatMapLatest() {
        var value = ""
        
        var subscriptionCount = 0
        var cancelCount = 0
        
        let first = CurrentValueSubject<String, Never>("👦🏻")
        let second = CurrentValueSubject<String, Never>("🅰️")
        
        let subject = CurrentValueSubject<AnyPublisher<String, Never>, Never>(first.eraseToAnyPublisher())
        
        self.subscription = subject
            .flatMapLatest { 
                return $0.handleEvents(receiveSubscription: { _ in
                    subscriptionCount += 1
                }, receiveCancel: {
                    cancelCount += 1
                })
                .eraseToAnyPublisher()
            }
            .sink {
                value.append($0)
            }
        
        first.send("🐱")
        
        subject.send(second.eraseToAnyPublisher())
        
        first.send("🐶")
        second.send("🅱️")
        
        XCTAssertEqual(value, "👦🏻🐱🅰️🅱️")
        XCTAssertEqual(subscriptionCount, 2)
        XCTAssertEqual(cancelCount, 1)
    }
}

#endif
