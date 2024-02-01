//
//  FlatMapFirst.swift
//
//  Created by Max on 2024/1/26
//
//  Copyright © 2024 Max. All rights reserved.
//

#if canImport(Combine)

import Combine
import class Foundation.NSRecursiveLock

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publisher {
    func flatMapFirst<P>(_ transform: @escaping (Output) -> P) -> Publishers.FlatMap<Publishers.HandleEvents<P>, Publishers.Filter<Self>> where P: Publisher, P.Failure == Failure {
        let lock = NSRecursiveLock()
        
        var isActive = false
        
        func setActive(_ newValue: Bool) {
            lock.lock()
            defer {
                lock.unlock()
            }
            
            isActive = newValue
        }
        
        return self
            .filter { _ in !isActive }
            .flatMap { output in
                transform(output)
                    .handleEvents(receiveSubscription: { _ in
                        setActive(true)
                    }, receiveCompletion: { _ in
                        setActive(false)
                    }, receiveCancel: {
                        setActive(false)
                    })
            }
    }
}

#endif
