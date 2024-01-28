//
//  MapToValue.swift
//
//  Created by Max on 2024/1/28
//
//  Copyright © 2024 Max. All rights reserved.
//

#if canImport(Combine)

import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publisher {
    func mapToValue<T>(_ value: T) -> Publishers.Map<Self, T> {
        return self.map { _ in value }
    }

    func mapToVoid() -> Publishers.Map<Self, Void> {
        return self.map { _ in }
    }
}

#endif
