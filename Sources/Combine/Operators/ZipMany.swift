//
//  ZipMany.swift
//  SBExtensions
//
//  Created by 菅思博 on 2024/1/26.
//

#if canImport(Combine)

import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publisher {
    func zip<P>(with others: P...) -> AnyPublisher<[Output], Failure> where P: Publisher, P.Output == Output, P.Failure == Failure {
        return self.zip(with: others)
    }
    
    func zip<S>(with others: S) -> AnyPublisher<[Output], Failure> where S: Collection, S.Element: Publisher, S.Element.Output == Output, S.Element.Failure == Failure {
        return ([self.eraseToAnyPublisher()] + others.map { $0.eraseToAnyPublisher() }).zip()
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Collection where Element: Publisher {
    func zip() -> AnyPublisher<[Element.Output], Element.Failure> {
        var wrapped = self.map { $0.map { [$0] }.eraseToAnyPublisher() }
        
        while wrapped.count > 1 {
            wrapped = makeZippedQuads(input: wrapped)
        }
        
        return wrapped.first?.eraseToAnyPublisher() ?? Empty().eraseToAnyPublisher()
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
private func makeZippedQuads<Output, Failure>(input: [AnyPublisher<[Output], Failure>]) -> [AnyPublisher<[Output], Failure>] where Failure: Swift.Error {
    return sequence(state: input.makeIterator(), next: { input in input.next().map { ($0, input.next(), input.next(), input.next()) } })
        .map { quads in
            guard let second = quads.1 else {
                return quads.0
            }
            
            guard let third = quads.2 else {
                return quads.0
                    .zip(second)
                    .map { $0.0 + $0.1 }
                    .eraseToAnyPublisher()
            }
            
            guard let fourth = quads.3 else {
                return quads.0
                    .zip(second, third)
                    .map { $0.0 + $0.1 + $0.2 }
                    .eraseToAnyPublisher()
            }
            
            return quads.0
                .zip(second, third, fourth)
                .map { $0.0 + $0.1 + $0.2 + $0.3 }
                .eraseToAnyPublisher()
        }
}

#endif
