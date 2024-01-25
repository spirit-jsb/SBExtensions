//
//  WithLatestFromTests.swift
//  SBExtensionsTests
//
//  Created by 菅思博 on 2024/1/25.
//

@testable import SBExtensions
import XCTest

#if canImport(Combine)

import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
final class WithLatestFromTests: XCTestCase {
    var subscription: AnyCancellable!
    
    func testWithLatestFrom() {
        var value = [String]()
        
        var isCompleted = false
        
        let first = PassthroughSubject<Int, Never>()
        let second = PassthroughSubject<String, Never>()
        
        self.subscription = first
            .withLatestFrom(second) { "\($0)\($1)" }
            .sink(receiveCompletion: { _ in
                isCompleted = true
            }, receiveValue: {
                value.append($0)
            })
        
        first.send(1)
        first.send(2)
        first.send(3)
        
        second.send("a")
        
        first.send(4)
        first.send(5)
        
        second.send("b")
        second.send("c")
        
        first.send(6)
        
        second.send("d")
        second.send("e")
        second.send("f")
        
        XCTAssertEqual(value, ["4a", "5a", "6c"])
        
        XCTAssertFalse(isCompleted)
        
        second.send(completion: .finished)
        
        XCTAssertFalse(isCompleted)
        
        first.send(completion: .finished)
        
        XCTAssertTrue(isCompleted)
    }
}

#endif
