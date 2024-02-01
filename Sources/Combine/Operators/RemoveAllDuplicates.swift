//
//  RemoveAllDuplicates.swift
//
//  Created by Max on 2024/1/28
//
//  Copyright © 2024 Max. All rights reserved.
//

#if canImport(Combine)

import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publisher where Output: Hashable {
    func removeAllDuplicates() -> Publishers.Filter<Self> {
        var uniqueOutputs = Set<Output>()
        
        return self.filter { uniqueOutputs.insert($0).inserted }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publisher where Output: Equatable {
    func removeAllDuplicates() -> Publishers.Filter<Self> {
        return self.removeAllDuplicates(by: ==)
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publisher {
    func removeAllDuplicates(by predicate: @escaping (Output, Output) -> Bool) -> Publishers.Filter<Self> {
        var uniqueOutputs = [Output]()
        
        return self.filter { element in
            if uniqueOutputs.contains(where: { predicate($0, element) }) {
                return false
            } else {
                uniqueOutputs.append(element)
                
                return true
            }
        }
    }
}

#endif
