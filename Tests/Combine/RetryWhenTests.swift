//
//  RetryWhenTests.swift
//  SBExtensionsTests
//
//  Created by 菅思博 on 2024/1/30.
//

@testable import SBExtensions
import XCTest

#if canImport(Combine)

import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
final class RetryWhenTests: XCTestCase {
    enum TestableError: Swift.Error {
        case error
        case retryError
    }
    
    var cancellable: AnyCancellable!
    
    func testRetrySuccess() {
        var values = [Int]()
        
        var completion: Subscribers.Completion<TestableError>?
        
        var times = 0
        
        self.cancellable = Deferred {
            defer {
                times += 1
            }
            
            if times == 0 {
                return Fail<Int, TestableError>(error: TestableError.error).eraseToAnyPublisher()
            } else {
                return Just(10).setFailureType(to: TestableError.self).eraseToAnyPublisher()
            }
        }.retryWhen { $0.map { _ in } }
            .sink(receiveCompletion: {
                completion = $0
            }, receiveValue: {
                values.append($0)
            })
        
        XCTAssertEqual(values, [10])
        XCTAssertEqual(completion, .finished)
        XCTAssertEqual(times, 2)
    }
    
    func testRetryFailure() {
        var values = [Int]()
        
        var completion: Subscribers.Completion<TestableError>?
        
        self.cancellable = Fail<Int, TestableError>(error: TestableError.error)
            .retryWhen { $0.tryMap { _ in throw TestableError.retryError } }
            .sink(receiveCompletion: {
                completion = $0
            }, receiveValue: {
                values.append($0)
            })
        
        XCTAssertEqual(values, [])
        XCTAssertEqual(completion, .failure(TestableError.retryError))
    }
    
    func testRetryComplete() {
        var values = [Int]()
        
        var completion: Subscribers.Completion<TestableError>?
        
        self.cancellable = Fail<Int, TestableError>(error: TestableError.error)
            .retryWhen { $0.prefix(1) }
            .sink(receiveCompletion: {
                completion = $0
            }, receiveValue: {
                values.append($0)
            })
        
        XCTAssertEqual(values, [])
        XCTAssertEqual(completion, .finished)
    }
    
    func testRetryWhen() {
        var value = ""
        
        var completion: Subscribers.Completion<TestableError>?
        
        var count = 1
        
        self.cancellable = AnyPublisher<String, TestableError>.create { subscribe in
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
        }.retryWhen { $0.map { _ in } }
            .sink(receiveCompletion: {
                completion = $0
            }, receiveValue: {
                value.append($0)
            })
        
        XCTAssertEqual(value, "0⃣️1⃣️2⃣️0⃣️1⃣️2⃣️0⃣️1⃣️2⃣️3⃣️4⃣️5⃣️")
        XCTAssertEqual(completion, .finished)
        XCTAssertEqual(count, 3)
    }
}

#endif
