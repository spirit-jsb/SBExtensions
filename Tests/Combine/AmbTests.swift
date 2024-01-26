//
//  AmbTests.swift
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
final class AmbTests: XCTestCase {
    var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        
        self.cancellables = Set()
    }
    
    func testAmb() {
        var values = [Int]()
        
        var isCompleted = false
        
        let subject1 = PassthroughSubject<Int, Never>()
        let subject2 = PassthroughSubject<Int, Never>()
        
        subject1
            .amb(subject2)
            .sink(receiveCompletion: { _ in
                isCompleted = true
            }, receiveValue: {                
                values.append($0)
            })
            .store(in: &self.cancellables)
        
        subject2.send(1)
        subject1.send(2)
        subject1.send(3)
        subject2.send(4)
        
        XCTAssertEqual(values, [1, 4])
        
        subject1.send(completion: .finished)
        
        XCTAssertFalse(isCompleted)
        
        subject2.send(completion: .finished)
        
        XCTAssertTrue(isCompleted)
    }
    
    func testAmbLimitPreDemand() {
        var values = [Int]()
                
        let subject1 = PassthroughSubject<Int, Never>()
        let subject2 = PassthroughSubject<Int, Never>()
        
        let subscriber = AnySubscriber<Int, Never>(receiveSubscription: { subscription in
            subscription.request(.max(3))
            
            subject2.send(1)
            subject1.send(2)
            subject1.send(3)
            subject2.send(4)
            subject1.send(5)
            subject1.send(6)
            subject2.send(7)
            subject1.send(8)
            subject1.send(9)
            subject2.send(0)
        }, receiveValue: {
            values.append($0)
            
            return .none
        }, receiveCompletion: { _ in
            
        })
        
        subject1
            .amb(subject2)
            .subscribe(subscriber)
        
        XCTAssertEqual(values, [1, 4, 7])
    }
    
    func testEmptySubjectAmb() {
        var value1 = [Int]()
        
        var isCompleted1 = false
        
        let subject1 = Empty<Int, Never>(completeImmediately: false).append(0)
        let subject2 = Empty<Int, Never>(completeImmediately: true).append(1)
        
        subject1
            .amb(subject2)
            .sink(receiveCompletion: { _ in
                isCompleted1 = true
            }, receiveValue: {
                value1.append($0)
            })
            .store(in: &self.cancellables)
        
        XCTAssertEqual(value1, [1])
        XCTAssertTrue(isCompleted1)
        
        var value2 = [Int]()
        
        var isCompleted2 = false
        
        let subject3 = Empty<Int, Never>(completeImmediately: true).append(2)
        let subject4 = Empty<Int, Never>(completeImmediately: true).append(3)
        
        subject3
            .amb(subject4)
            .sink(receiveCompletion: { _ in
                isCompleted2 = true
            }, receiveValue: {
                value2.append($0)
            })
            .store(in: &self.cancellables)
        
        XCTAssertEqual(value2, [2])
        XCTAssertTrue(isCompleted2)
        
        var value3 = [Int]()
        
        var isCompleted3 = false
        
        let subject5 = Empty<Int, Never>(completeImmediately: false).append(4)
        let subject6 = Empty<Int, Never>(completeImmediately: false).append(5)
        
        subject5
            .amb(subject6)
            .sink(receiveCompletion: { _ in
                isCompleted3 = true
            }, receiveValue: {
                value3.append($0)
            })
            .store(in: &self.cancellables)
        
        XCTAssertEqual(value3, [])
        XCTAssertFalse(isCompleted3)
    }
    
    func testVariadicValuesAmb() {
        var value1 = [Int]()
        var value2 = [Int]()
        var value3 = [Int]()
        
        var isCompleted1 = false
        var isCompleted2 = false
        var isCompleted3 = false
        
        let subject1 = PassthroughSubject<Int, Never>()
        let subject2 = PassthroughSubject<Int, Never>()
        let subject3 = PassthroughSubject<Int, Never>()
        let subject4 = PassthroughSubject<Int, Never>()
        
        subject4
            .amb(with: subject1, subject2, subject3)
            .sink(receiveCompletion: { _ in
                isCompleted1 = true
            }, receiveValue: {
                value1.append($0)
            })
            .store(in: &self.cancellables)
        
        subject1
            .amb(with: subject2, subject3)
            .sink(receiveCompletion: { _ in
                isCompleted2 = true
            }, receiveValue: {
                value2.append($0)
            })
            .store(in: &self.cancellables)
        
        subject1
            .amb(with: subject2)
            .sink(receiveCompletion: { _ in
                isCompleted3 = true
            }, receiveValue: {
                value3.append($0)
            })
            .store(in: &self.cancellables)
        
        subject4.send(1)
        subject3.send(4)
        subject2.send(7)
        subject1.send(0)
        subject4.send(2)
        subject3.send(5)
        subject2.send(8)
        subject1.send(0)
        subject4.send(3)
        subject3.send(6)
        subject2.send(9)
        
        XCTAssertEqual(value1, [1, 2, 3])
        XCTAssertEqual(value2, [4, 5, 6])
        XCTAssertEqual(value3, [7, 8, 9])
        
        subject1.send(completion: .finished)
        subject2.send(completion: .finished)
        
        XCTAssertFalse(isCompleted1)
        XCTAssertFalse(isCompleted2)
        XCTAssertTrue(isCompleted3)
        
        subject3.send(completion: .finished)
        
        XCTAssertFalse(isCompleted1)
        XCTAssertTrue(isCompleted2)
        
        subject4.send(completion: .finished)
        
        XCTAssertTrue(isCompleted1)
    }
    
    func testCollectionAmb() {
        var value1 = [Int]()
        var value2 = [Int]()
        var value3 = [Int]()
        
        var isCompleted1 = false
        var isCompleted2 = false
        var isCompleted3 = false
        
        let subject1 = PassthroughSubject<Int, Never>()
        let subject2 = PassthroughSubject<Int, Never>()
        let subject3 = PassthroughSubject<Int, Never>()
        let subject4 = PassthroughSubject<Int, Never>()
        
        [AnyPublisher<Int, Never>]().amb()
            .sink(receiveCompletion: { _ in
                isCompleted1 = true
            }, receiveValue: {
                value1.append($0)
            })
            .store(in: &self.cancellables)
        
        XCTAssertEqual(value1, [])
        XCTAssertTrue(isCompleted1)
        
        [subject1].amb()
            .sink(receiveCompletion: { _ in
                isCompleted2 = true
            }, receiveValue: {
                value2.append($0)
            })
            .store(in: &self.cancellables)
        
        subject1.send(1)
        subject1.send(completion: .finished)
        
        XCTAssertEqual(value2, [1])
        XCTAssertTrue(isCompleted2)
        
        [subject2, subject3, subject4].amb()
            .sink(receiveCompletion: { _ in
                isCompleted3 = true
            }, receiveValue: {
                value3.append($0)
            })
            .store(in: &self.cancellables)
        
        subject2.send(2)
        subject3.send(3)
        subject3.send(completion: .finished)
        subject4.send(4)
        subject4.send(completion: .finished)
        subject2.send(5)
        
        XCTAssertEqual(value3, [2, 5])
        XCTAssertFalse(isCompleted3)
        
        subject2.send(completion: .finished)
        
        XCTAssertTrue(isCompleted3)
    }
}

#endif
