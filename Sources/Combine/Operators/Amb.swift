//
//  Amb.swift
//
//  Created by Max on 2024/1/26
//
//  Copyright © 2024 Max. All rights reserved.
//

#if canImport(Combine)

import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publisher {
    func amb<P>(_ other: P) -> Publishers.Amb<Self, P> where P: Publisher, P.Output == Self.Output, P.Failure == Self.Failure {
        return Publishers.Amb(first: self, second: other)
    }
    
    func amb<P>(with others: P...) -> AnyPublisher<Self.Output, Self.Failure> where P: Publisher, P.Output == Self.Output, P.Failure == Self.Failure {
        return self.amb(with: others)
    }
    
    func amb<S>(with others: S) -> AnyPublisher<Self.Output, Self.Failure> where S: Collection, S.Element: Publisher, S.Element.Output == Self.Output, S.Element.Failure == Self.Failure {
        return others.reduce(self.eraseToAnyPublisher()) { $0.amb($1).eraseToAnyPublisher() }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Collection where Element: Publisher {
    func amb() -> AnyPublisher<Element.Output, Element.Failure> {
        switch self.count {
            case 0:
                return Empty().eraseToAnyPublisher()
            case 1:
                return self[startIndex].amb(with: [Element]())
            default:
                return self[startIndex].amb(with: self[index(after: startIndex)...])
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
private enum AmbDecision {
    case neither
    case first
    case second
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publishers {
    struct Amb<First, Second>: Publisher where First: Publisher, Second: Publisher, First.Output == Second.Output, First.Failure == Second.Failure {
        public typealias Output = First.Output
        public typealias Failure = First.Failure
        
        private let first: First
        private let second: Second
        
        public init(first: First, second: Second) {
            self.first = first
            self.second = second
        }
        
        public func receive<S>(subscriber: S) where S: Subscriber, S.Input == Output, S.Failure == Failure {
            subscriber.receive(subscription: Subscription(first: self.first, second: self.second, downstream: subscriber))
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
private extension Publishers.Amb {
    class Subscription<Downstream>: Combine.Subscription where Downstream: Subscriber, Downstream.Input == Output, Downstream.Failure == Failure {
        private var firstSink: Sink<First, Downstream>?
        private var secondSink: Sink<Second, Downstream>?
        
        private var preDecisionDemand = Subscribers.Demand.none
        
        private var decision: AmbDecision = .neither {
            didSet {
                switch self.decision {
                    case .first:
                        self.secondSink = nil
                    case .second:
                        self.firstSink = nil
                    default:
                        break
                }
                
                self.request(self.preDecisionDemand)
                
                self.preDecisionDemand = .none
            }
        }
        
        init(first: First, second: Second, downstream: Downstream) {
            self.firstSink = Sink(upstream: first, downstream: downstream) { [weak self] in
                guard let strongSelf = self, strongSelf.decision == .neither else {
                    return
                }
                
                strongSelf.decision = .first
            }
            
            self.secondSink = Sink(upstream: second, downstream: downstream) { [weak self] in
                guard let strongSelf = self, strongSelf.decision == .neither else {
                    return
                }
                
                strongSelf.decision = .second
            }
        }
        
        deinit {
            self.cancel()
        }
        
        func request(_ demand: Subscribers.Demand) {
            guard self.decision != .neither else {
                self.preDecisionDemand += demand
                
                return
            }
            
            self.firstSink?.demand(demand)
            self.secondSink?.demand(demand)
        }
        
        func cancel() {
            self.firstSink = nil
            self.secondSink = nil
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
private extension Publishers.Amb {
    class Sink<Upstream, Downstream>: SBExtensions.Sink<Upstream, Downstream> where Upstream: Publisher, Downstream: Subscriber, Upstream.Output == Downstream.Input, Upstream.Failure == Downstream.Failure {
        private let handler: () -> Void
        
        init(upstream: Upstream, downstream: Downstream, handler: @escaping () -> Void) {
            self.handler = handler
            
            super.init(upstream: upstream, downstream: downstream, transformOutput: { $0 }, transformFailure: { $0 })
        }
        
        override func receive(subscription: Combine.Subscription) {
            super.receive(subscription: subscription)
            
            subscription.request(.max(1))
        }
        
        override func receive(_ input: Upstream.Output) -> Subscribers.Demand {
            self.handler()
            
            return self.buffer.buffer(value: input)
        }
        
        override func receive(completion: Subscribers.Completion<Upstream.Failure>) {
            self.handler()
            
            self.buffer.complete(completion: completion)
        }
    }
}

#endif
