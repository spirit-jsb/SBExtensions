//
//  Create.swift
//
//  Created by Max on 2024/1/26
//
//  Copyright © 2024 Max. All rights reserved.
//

#if canImport(Combine)

import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension AnyPublisher {
    static func create(_ subscribe: @escaping Publishers.Create<Output, Failure>.SubscribeHandler) -> AnyPublisher<Output, Failure> {
        return AnyPublisher(subscribe)
    }
    
    init(_ subscribe: @escaping Publishers.Create<Output, Failure>.SubscribeHandler) {
        self = Publishers.Create(subscribeHandler: subscribe).eraseToAnyPublisher()
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publishers {
    struct Create<Output, Failure>: Publisher where Failure: Error {
        public typealias SubscribeHandler = (Subscriber) -> Cancellable
        
        private let subscribeHandler: SubscribeHandler
        
        public init(subscribeHandler: @escaping SubscribeHandler) {
            self.subscribeHandler = subscribeHandler
        }
        
        public func receive<S>(subscriber: S) where S: Combine.Subscriber, S.Input == Output, S.Failure == Failure {
            subscriber.receive(subscription: Subscription(downstream: subscriber, subscribeHandler: self.subscribeHandler))
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publishers.Create {
    struct Subscriber {
        private let valueHandler: (Output) -> Void
        private let completionHandler: (Subscribers.Completion<Failure>) -> Void
        
        init(valueHandler: @escaping (Output) -> Void, completionHandler: @escaping (Subscribers.Completion<Failure>) -> Void) {
            self.valueHandler = valueHandler
            self.completionHandler = completionHandler
        }
        
        public func send(_ input: Output) {
            self.valueHandler(input)
        }
        
        public func send(completion: Subscribers.Completion<Failure>) {
            self.completionHandler(completion)
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
private extension Publishers.Create {
    class Subscription<Downstream>: Combine.Subscription where Downstream: Combine.Subscriber, Downstream.Input == Output, Downstream.Failure == Failure {
        private let demandBuffer: DemandBuffer<Downstream>
        
        private var cancellable: Cancellable?
        
        init(downstream: Downstream, subscribeHandler: @escaping SubscribeHandler) {
            self.demandBuffer = DemandBuffer(subscriber: downstream)
            
            let subscriber = Subscriber(valueHandler: { [weak self] in
                _ = self?.demandBuffer.buffer($0)
            }, completionHandler: { [weak self] in
                self?.demandBuffer.complete(completion: $0)
            })
            
            self.cancellable = subscribeHandler(subscriber)
        }
        
        func request(_ demand: Subscribers.Demand) {
            _ = self.demandBuffer.demand(demand)
        }
        
        func cancel() {
            self.cancellable?.cancel()
            self.cancellable = nil
        }
    }
}

#endif
