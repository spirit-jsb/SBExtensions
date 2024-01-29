//
//  ShareReplay.swift
//
//  Created by Max on 2024/1/29
//
//  Copyright © 2024 Max. All rights reserved.
//

#if canImport(Combine)

import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publisher {
    func shareReplay(_ replay: Int) -> Publishers.Autoconnect<Publishers.Multicast<Self, ReplaySubject<Output, Failure>>> {
        return self.multicast { ReplaySubject(bufferSize: replay) }.autoconnect()
    }
}

#endif
