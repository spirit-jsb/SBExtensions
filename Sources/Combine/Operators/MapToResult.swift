//
//  MapToResult.swift
//
//  Created by Max on 2024/1/27
//
//  Copyright © 2024 Max. All rights reserved.
//

#if canImport(Combine)

import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publisher {
    func mapToResult() -> AnyPublisher<Result<Output, Failure>, Never> {
        return self.map(Result.success)
            .catch { Just(.failure($0)) }
            .eraseToAnyPublisher()
    }
}

#endif
