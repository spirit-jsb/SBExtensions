//
//  MergeMany.swift
//
//  Created by Max on 2024/1/28
//
//  Copyright © 2024 Max. All rights reserved.
//

#if canImport(Combine)

import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Collection where Element: Publisher {
    func merge() -> AnyPublisher<Element.Output, Element.Failure> {
        return Publishers.MergeMany(self).eraseToAnyPublisher()
    }
}

#endif
