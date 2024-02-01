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
    func withLatestFrom<P, T>(_ other: P, resultSelector: @escaping (Output, P.Output) -> T) -> Publishers.WithLatestFrom<Self, P, T> where P: Publisher {
        return .init(upstream: self, other: other, resultSelector: resultSelector)
    }
    
    func withLatestFrom<P, Q, T>(_ other: P, _ other1: Q, resultSelector: @escaping (Output, (P.Output, Q.Output)) -> T) -> Publishers.WithLatestFrom<Self, AnyPublisher<(P.Output, Q.Output), Failure>, T> where P: Publisher, Q: Publisher, P.Failure == Failure, Q.Failure == Failure {
        let combined = other.combineLatest(other1).eraseToAnyPublisher()
        
        return .init(upstream: self, other: combined, resultSelector: resultSelector)
    }
    
    func withLatestFrom<P, Q, R, T>(_ other: P, _ other1: Q, _ other2: R, resultSelector: @escaping (Output, (P.Output, Q.Output, R.Output)) -> T) -> Publishers.WithLatestFrom<Self, AnyPublisher<(P.Output, Q.Output, R.Output), Failure>, T> where P: Publisher, Q: Publisher, R: Publisher, P.Failure == Failure, Q.Failure == Failure, R.Failure == Failure {
        let combined = other.combineLatest(other1, other2).eraseToAnyPublisher()
        
        return .init(upstream: self, other: combined, resultSelector: resultSelector)
    }
    
    func withLatestFrom<P>(_ other: P) -> Publishers.WithLatestFrom<Self, P, P.Output> where P: Publisher {
        return .init(upstream: self, other: other) { $1 }
    }
    
    func withLatestFrom<P, Q>(_ other: P, _ other1: Q) -> Publishers.WithLatestFrom<Self, AnyPublisher<(P.Output, Q.Output), Failure>, (P.Output, Q.Output)> where P: Publisher, Q: Publisher, P.Failure == Failure, Q.Failure == Failure {
        let combined = other.combineLatest(other1).eraseToAnyPublisher()
        
        return .init(upstream: self, other: combined) { $1 }
    }
    
    func withLatestFrom<P, Q, R>(_ other: P, _ other1: Q, _ other2: R) -> Publishers.WithLatestFrom<Self, AnyPublisher<(P.Output, Q.Output, R.Output), Failure>, (P.Output, Q.Output, R.Output)> where P: Publisher, Q: Publisher, R: Publisher, P.Failure == Failure, Q.Failure == Failure, R.Failure == Failure {
        let combined = other.combineLatest(other1, other2).eraseToAnyPublisher()
        
        return .init(upstream: self, other: combined) { $1 }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publishers {
    struct WithLatestFrom<Upstream, Other, Output>: Publisher where Upstream: Publisher, Other: Publisher, Other.Failure == Upstream.Failure {
        public typealias Failure = Upstream.Failure
        
        public typealias ResultSelector = (Upstream.Output, Other.Output) -> Output
        
        private let upstream: Upstream
        private let other: Other
        private let resultSelector: ResultSelector
        
        init(upstream: Upstream, other: Other, resultSelector: @escaping ResultSelector) {
            self.upstream = upstream
            self.other = other
            self.resultSelector = resultSelector
        }
        
        public func receive<S>(subscriber: S) where S: Subscriber, S.Input == Output, S.Failure == Failure {
            subscriber.receive(subscription: Subscription(upstream: self.upstream, downstream: subscriber, other: self.other, resultSelector: self.resultSelector))
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
private extension Publishers.WithLatestFrom {
    class Subscription<Downstream>: Combine.Subscription where Downstream: Subscriber, Downstream.Input == Output, Downstream.Failure == Failure {
        private let upstream: Upstream
        private let downstream: Downstream
        private let other: Other
        private let resultSelector: ResultSelector
        
        private var otherSubscription: Combine.Subscription?
        private var otherValue: Other.Output?
        
        private var sink: Sink<Upstream, Downstream>?
        
        private var preInitialDemand = Subscribers.Demand.none
        
        init(upstream: Upstream, downstream: Downstream, other: Other, resultSelector: @escaping ResultSelector) {
            self.upstream = upstream
            self.downstream = downstream
            self.other = other
            self.resultSelector = resultSelector
            
            self.trackLatestFromOther { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.request(strongSelf.preInitialDemand)
                strongSelf.preInitialDemand = .none
            }
        }
        
        func request(_ demand: Subscribers.Demand) {
            guard self.otherValue != nil else {
                self.preInitialDemand += demand
                
                return
            }
            
            self.sink?.request(demand)
        }
        
        func cancel() {
            self.otherSubscription?.cancel()
            self.otherSubscription = nil
            
            self.sink?.cancelUpstreamSubscription()
            self.sink = nil
        }
        
        private func trackLatestFromOther(initialization: @escaping () -> Void) {
            var initializationNotReady = true
            
            let subscriber = AnySubscriber<Other.Output, Other.Failure>(receiveSubscription: { [weak self] in
                self?.otherSubscription = $0
                
                $0.request(.unlimited)
            }, receiveValue: { [weak self] in
                guard let self = self else {
                    return .none
                }
                
                self.otherValue = $0
                
                if initializationNotReady {
                    self.sink = Sink(upstream: self.upstream, downstream: self.downstream, transformOutput: { [weak self] in
                        guard let strongSelf = self, let otherValue = strongSelf.otherValue else {
                            return nil
                        }
                        
                        return strongSelf.resultSelector($0, otherValue)
                    }, transformFailure: {
                        $0
                    })
                    
                    initializationNotReady = false
                    
                    initialization()
                }
                
                return .unlimited
            }, receiveCompletion: { _ in
                
            })
            
            self.other.subscribe(subscriber)
        }
    }
}

#endif
