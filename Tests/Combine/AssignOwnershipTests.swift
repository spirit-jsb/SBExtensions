//
//  AssignOwnershipTests.swift
//  SBExtensionsTests
//
//  Created by 菅思博 on 2024/1/25.
//

@testable import SBExtensions
import XCTest

#if canImport(Combine)

import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
final class AssignOwnershipTests: XCTestCase {
    var subject: PassthroughSubject<Int, Never>!
    
    var subscription: AnyCancellable!
    
    var value = 0
    
    override func setUp() {
        super.setUp()
        
        self.value = 0
        
        self.subscription = nil
        
        self.subject = PassthroughSubject<Int, Never>()
    }
    
    func testStrongOwnership() {
        let initialRetainCount = CFGetRetainCount(self)
        
        self.subscription = self.subject
            .assign(to: \.value, on: self, ownership: .strong)
        
        self.subject.send(10)
        
        let retainCountResult = CFGetRetainCount(self)
        
        XCTAssertEqual(retainCountResult, initialRetainCount + 1)
    }
    
    func testWeakOwnership() {
        let initialRetainCount = CFGetRetainCount(self)
        
        self.subscription = self.subject
            .assign(to: \.value, on: self, ownership: .weak)
        
        self.subject.send(10)
        
        let retainCountResult = CFGetRetainCount(self)
        
        XCTAssertEqual(retainCountResult, initialRetainCount)
    }
    
    func testUnownedOwnership() {
        let initialRetainCount = CFGetRetainCount(self)
        
        self.subscription = self.subject
            .assign(to: \.value, on: self, ownership: .unowned)
        
        self.subject.send(10)
        
        let retainCountResult = CFGetRetainCount(self)
        
        XCTAssertEqual(retainCountResult, initialRetainCount)
        
    }
}

#endif
