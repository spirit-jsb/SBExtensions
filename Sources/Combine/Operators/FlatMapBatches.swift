//
//  FlatMapBatches.swift
//
//  Created by Max on 2024/1/26
//
//  Copyright © 2024 Max. All rights reserved.
//

#if canImport(Combine)

import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Collection where Element: Publisher {
    func flatMapBatches(of size: Int) -> AnyPublisher<[Element.Output], Element.Failure> {
        precondition(size > 0, "Batch sizes must be positive")
        
        let indexBreaks = sequence(first: startIndex, next: { $0 == endIndex ? nil : index($0, offsetBy: size, limitedBy: endIndex) ?? endIndex })
        
        return Swift.zip(indexBreaks, indexBreaks.dropFirst())
            .publisher
            .setFailureType(to: Element.Failure.self)
            .flatMap(maxPublishers: .max(1)) { self[$0..<$1].zip() }
            .eraseToAnyPublisher()
    }
}

#endif
