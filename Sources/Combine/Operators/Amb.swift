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
    func amb<P>(_ other: P) -> Publishers.Amb<Self, P> where P: Publisher, P.Output == Output, P.Failure == Failure {
        return Publishers.Amb(left: self, right: other)
    }
    
    func amb<P>(with others: P...) -> AnyPublisher<Output, Failure> where P: Publisher, P.Output == Output, P.Failure == Failure {
        return self.amb(with: others)
    }
    
    func amb<S>(with others: S) -> AnyPublisher<Output, Failure> where S: Collection, S.Element: Publisher, S.Element.Output == Output, S.Element.Failure == Failure {
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
    case left
    case right
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publishers {
    struct Amb<Left, Right>: Publisher where Left: Publisher, Right: Publisher, Left.Output == Right.Output, Left.Failure == Right.Failure {
        public typealias Output = Left.Output
        public typealias Failure = Left.Failure
        
        private let left: Left
        private let right: Right
        
        public init(left: Left, right: Right) {
            self.left = left
            self.right = right
        }
        
        public func receive<S>(subscriber: S) where S: Subscriber, S.Input == Output, S.Failure == Failure {
            subscriber.receive(subscription: Subscription(left: self.left, right: self.right, downstream: subscriber))
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
private extension Publishers.Amb {
    class Subscription<Downstream>: Combine.Subscription where Downstream: Subscriber, Downstream.Input == Output, Downstream.Failure == Failure {
        private var leftSink: Sink<Left, Downstream>?
        private var rightSink: Sink<Right, Downstream>?
        
        private var preInitialDemand = Subscribers.Demand.none
        
        private var decision: AmbDecision = .neither {
            didSet {
                switch self.decision {
                    case .left:
                        self.rightSink = nil
                    case .right:
                        self.leftSink = nil
                    default:
                        break
                }
                
                self.request(self.preInitialDemand)
                self.preInitialDemand = .none
            }
        }
        
        init(left: Left, right: Right, downstream: Downstream) {
            self.leftSink = Sink(upstream: left, downstream: downstream) { [weak self] in
                guard self?.decision == .neither else {
                    return
                }
                
                self?.decision = .left
            }
            
            self.rightSink = Sink(upstream: right, downstream: downstream) { [weak self] in
                guard self?.decision == .neither else {
                    return
                }
                
                self?.decision = .right
            }
        }
        
        func request(_ demand: Subscribers.Demand) {
            guard self.decision != .neither else {
                self.preInitialDemand += demand
                
                return
            }
            
            self.leftSink?.request(demand)
            self.rightSink?.request(demand)
        }
        
        func cancel() {
            self.leftSink?.cancelUpstreamSubscription()
            self.leftSink = nil
            
            self.rightSink?.cancelUpstreamSubscription()
            self.rightSink = nil
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
private extension Publishers.Amb {
    class Sink<Upstream, Downstream>: SBExtensions.Sink<Upstream, Downstream> where Upstream: Publisher, Downstream: Subscriber, Upstream.Output == Downstream.Input, Upstream.Failure == Downstream.Failure {
        private let triggerHandler: () -> Void
        
        init(upstream: Upstream, downstream: Downstream, triggerHandler: @escaping () -> Void) {
            self.triggerHandler = triggerHandler
            
            super.init(upstream: upstream, downstream: downstream, transformOutput: { $0 }, transformFailure: { $0 })
        }
        
        override func receive(subscription: Combine.Subscription) {
            super.receive(subscription: subscription)
            
            subscription.request(.max(1))
        }
        
        override func receive(_ input: Upstream.Output) -> Subscribers.Demand {
            self.triggerHandler()
            
            return self.demandBuffer.buffer(input)
        }
        
        override func receive(completion: Subscribers.Completion<Upstream.Failure>) {
            self.triggerHandler()
            
            self.demandBuffer.complete(completion: completion)
        }
    }
}

#endif
