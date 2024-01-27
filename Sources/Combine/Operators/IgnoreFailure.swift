//
//  IgnoreFailure.swift
//
//  Created by Max on 2024/1/27
//
//  Copyright © 2024 Max. All rights reserved.
//

#if canImport(Combine)

import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publisher {
    func ignoreFailure(completeImmediately: Bool = true) -> AnyPublisher<Output, Never> {
        return self.catch { _ in Empty(completeImmediately: completeImmediately) }.eraseToAnyPublisher()
    }

    func ignoreFailure<E>(failureType: E.Type, completeImmediately: Bool = true) -> AnyPublisher<Output, E> where E: Swift.Error {
        return self.ignoreFailure(completeImmediately: completeImmediately)
            .setFailureType(to: failureType)
            .eraseToAnyPublisher()
    }
}

#endif
