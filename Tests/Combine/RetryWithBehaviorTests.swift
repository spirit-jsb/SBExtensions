//
//  RetryWithBehaviorTests.swift
//  SBExtensionsTests
//
//  Created by 菅思博 on 2024/1/30.
//

@testable import SBExtensions
import XCTest

#if canImport(Combine)

import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
final class RetryWithBehaviorTests: XCTestCase {
    enum TestableError: Swift.Error {
        case error
        case retryError
    }
    
    var cancellable: AnyCancellable!
    
    func testA() {
        var value = ""
        
        var completion: Subscribers.Completion<TestableError>?
        
        var count = 0
        
        self.cancellable =  AnyPublisher<String, TestableError>.create { subscribe in
            subscribe.send("0⃣️")
            subscribe.send("1⃣️")
            subscribe.send("2⃣️")
            
            if count < 3 {
                subscribe.send(completion: .failure(TestableError.error))
                
                count += 1
            } else {
                subscribe.send("3⃣️")
                subscribe.send("4⃣️")
                subscribe.send("5⃣️")
                subscribe.send(completion: .finished)
            }
            
            return AnyCancellable {  }
        }.retry(.immediate(maxCount: 3), scheduler: DispatchQueue.main)
            .sink(receiveCompletion: {
                completion = $0
            }, receiveValue: {
                value.append($0)
            })
        
        XCTAssertEqual(value, "0⃣️1⃣️2⃣️0⃣️1⃣️2⃣️0⃣️1⃣️2⃣️0⃣️1⃣️2⃣️3⃣️4⃣️5⃣️")
        XCTAssertEqual(completion, .finished)
        XCTAssertEqual(count, 3)
    }
}

#endif
