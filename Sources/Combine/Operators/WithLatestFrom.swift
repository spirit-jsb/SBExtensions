//
//  WithLatestFrom.swift
//
//  Created by Max on 2024/1/26
//
//  Copyright © 2024 Max. All rights reserved.
//

#if canImport(Combine)

import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publisher {
    func withLatestFrom<P, T>(_ other: P, resultSelector: @escaping (Self.Output, P.Output) -> T) -> Publishers.WithLatestFrom<Self, P, T> where P: Publisher {
        return .init(upstream: self, second: other, resultSelector: resultSelector)
    }
    
    func withLatestFrom<P, Q, T>(_ other: P, _ other1: Q, resultSelector: @escaping (Self.Output, (P.Output, Q.Output)) -> T) -> Publishers.WithLatestFrom<Self, AnyPublisher<(P.Output, Q.Output), Self.Failure>, T> where P: Publisher, Q: Publisher, P.Failure == Self.Failure, Q.Failure == Self.Failure {
        let combined = other.combineLatest(other1).eraseToAnyPublisher()
        
        return .init(upstream: self, second: combined, resultSelector: resultSelector)
    }
    
    func withLatestFrom<P, Q, R, T>(_ other: P, _ other1: Q, _ other2: R, resultSelector: @escaping (Self.Output, (P.Output, Q.Output, R.Output)) -> T) -> Publishers.WithLatestFrom<Self, AnyPublisher<(P.Output, Q.Output, R.Output), Self.Failure>, T> where P: Publisher, Q: Publisher, R: Publisher, P.Failure == Self.Failure, Q.Failure == Self.Failure, R.Failure == Self.Failure {
        let combined = other.combineLatest(other1, other2).eraseToAnyPublisher()
        
        return .init(upstream: self, second: combined, resultSelector: resultSelector)
    }
    
    func withLatestFrom<P>(_ other: P) -> Publishers.WithLatestFrom<Self, P, P.Output> where P: Publisher {
        return .init(upstream: self, second: other) { $1 }
    }
    
    func withLatestFrom<P, Q>(_ other: P, _ other1: Q) -> Publishers.WithLatestFrom<Self, AnyPublisher<(P.Output, Q.Output), Self.Failure>, (P.Output, Q.Output)> where P: Publisher, Q: Publisher, P.Failure == Self.Failure, Q.Failure == Self.Failure {
        let combined = other.combineLatest(other1).eraseToAnyPublisher()
        
        return .init(upstream: self, second: combined) { $1 }
    }
    
    func withLatestFrom<P, Q, R>(_ other: P, _ other1: Q, _ other2: R) -> Publishers.WithLatestFrom<Self, AnyPublisher<(P.Output, Q.Output, R.Output), Self.Failure>, (P.Output, Q.Output, R.Output)> where P: Publisher, Q: Publisher, R: Publisher, P.Failure == Self.Failure, Q.Failure == Self.Failure, R.Failure == Self.Failure {
        let combined = other.combineLatest(other1, other2).eraseToAnyPublisher()
        
        return .init(upstream: self, second: combined) { $1 }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publishers {
    struct WithLatestFrom<Upstream, Other, Output>: Publisher where Upstream: Publisher, Other: Publisher, Upstream.Failure == Other.Failure {
        public typealias Failure = Upstream.Failure
        public typealias ResultSelector = (Upstream.Output, Other.Output) -> Output
        
        private let upstream: Upstream
        private let second: Other
        private let resultSelector: ResultSelector
        
        init(upstream: Upstream, second: Other, resultSelector: @escaping ResultSelector) {
            self.upstream = upstream
            self.second = second
            self.resultSelector = resultSelector
        }
        
        public func receive<S>(subscriber: S) where S: Subscriber, Upstream.Failure == S.Failure, Output == S.Input {
            subscriber.receive(subscription: Subscription(upstream: self.upstream, downstream: subscriber, second: self.second, resultSelector: self.resultSelector))
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
private extension Publishers.WithLatestFrom {
    class Subscription<Downstream>: Combine.Subscription where Downstream: Subscriber, Downstream.Input == Output, Downstream.Failure == Failure {
        var description: String {
            return "WithLatestFrom.Subscription<\(Output.self), \(Failure.self)>"
        }
        
        private let upstream: Upstream
        private let downstream: Downstream
        private let second: Other
        private let resultSelector: ResultSelector
        
        private var otherSubscription: Cancellable?
        private var latestValue: Other.Output?
        
        private var sink: Sink<Upstream, Downstream>?
        
        private var preInitialDemand = Subscribers.Demand.none
        
        init(upstream: Upstream, downstream: Downstream, second: Other, resultSelector: @escaping ResultSelector) {
            self.upstream = upstream
            self.downstream = downstream
            self.second = second
            self.resultSelector = resultSelector
            
            self.trackLatestFromSecond { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.request(strongSelf.preInitialDemand)
                
                strongSelf.preInitialDemand = .none
            }
        }
        
        deinit {
            self.cancel()
        }
        
        func request(_ demand: Subscribers.Demand) {
            guard self.latestValue != nil else {
                self.preInitialDemand += demand
                
                return
            }
            
            self.sink?.demand(demand)
        }
        
        func cancel() {
            self.sink?.cancelUpstream()
            self.sink = nil
            
            self.otherSubscription?.cancel()
        }
        
        private func trackLatestFromSecond(initialization: @escaping () -> Void) {
            var initializationNotReady = true
            
            let subscriber = AnySubscriber<Other.Output, Other.Failure>(receiveSubscription: { [weak self] subscription in
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.otherSubscription = subscription
                
                subscription.request(.unlimited)
            }, receiveValue: { [weak self] value in
                guard let strongSelf = self else {
                    return .none
                }
                
                strongSelf.latestValue = value
                
                if initializationNotReady {
                    strongSelf.sink = Sink(upstream: strongSelf.upstream, downstream: strongSelf.downstream, transformOutput: { [weak strongSelf] value in
                        guard let strongSelf = strongSelf, let otherValue = strongSelf.latestValue else {
                            return nil
                        }
                        
                        return strongSelf.resultSelector(value, otherValue)
                    }, transformFailure: { error in
                        return error
                    })
                    
                    initializationNotReady = false
                    initialization()
                }
                
                return .unlimited
            }, receiveCompletion: nil)
            
            self.second.subscribe(subscriber)
        }
    }
}

#endif
