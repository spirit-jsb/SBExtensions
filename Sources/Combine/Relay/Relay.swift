//
//  Relay.swift
//  SBExtensions
//
//  Created by 菅思博 on 2024/1/29.
//

#if canImport(Combine)

import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol Relay: Publisher where Failure == Never {
    associatedtype Output
    
    func accept(_ value: Output)
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publisher where Failure == Never {
    func subscribe<P>(_ publisher: P) -> AnyCancellable where P: Relay, P.Output == Output {
        return self.sink(receiveValue: {
            publisher.accept($0)
        })
    }
}

#endif
