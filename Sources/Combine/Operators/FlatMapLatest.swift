//
//  FlatMapLatest.swift
//
//  Created by Max on 2024/1/26
//
//  Copyright © 2024 Max. All rights reserved.
//

#if canImport(Combine)

import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publisher {
    func flatMapLatest<P>(_ transform: @escaping (Self.Output) -> P) -> Publishers.SwitchToLatest<P, Publishers.Map<Self, P>> where P: Publisher {
        return self.map(transform).switchToLatest()
    }
}

#endif
