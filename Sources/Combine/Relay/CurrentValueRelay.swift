//
//  CurrentValueRelay.swift
//  SBExtensions
//
//  Created by 菅思博 on 2024/1/29.
//

#if canImport(Combine)

import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public class CurrentValueRelay<Output>: Relay {
    public var value: Output {
        return self.subject.value
    }
    
    private let subject: CurrentValueSubject<Output, Never>
    
    private var subscriptions = [Subscription<CurrentValueSubject<Output, Never>, AnySubscriber<Output, Never>>]()
    
    public init(_ value: Output) {
        self.subject = CurrentValueSubject(value)
    }
    
    deinit {
        self.subscriptions.forEach { $0.forceFinish() }
    }
    
    public func accept(_ value: Output) {
        self.subject.send(value)
    }
    
    public func subscribe<P>(_ publisher: P) -> AnyCancellable where P: Publisher, P.Output == Output, P.Failure == Never {
        publisher.subscribe(self.subject)
    }
    
    public func receive<S>(subscriber: S) where S: Subscriber,S.Input == Output, S.Failure == Never {
        let subscription = Subscription(upstream: self.subject, downstream: AnySubscriber(subscriber))
        
        self.subscriptions.append(subscription)
        
        subscriber.receive(subscription: subscription)
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
private extension CurrentValueRelay {
    class Subscription<Upstream, Downstream>: Combine.Subscription where Upstream: Publisher, Downstream: Subscriber, Upstream.Output == Downstream.Input, Upstream.Failure == Downstream.Failure {
        private var sink: Sink<Upstream, Downstream>?
        
        init(upstream: Upstream, downstream: Downstream) {
            self.sink = Sink(upstream: upstream, downstream: downstream, transformOutput: { $0 })
        }
        
        func request(_ demand: Subscribers.Demand) {
            self.sink?.demand(demand)
        }
        
        func cancel() {
            self.sink = nil
        }
        
        func forceFinish() {
            self.sink?.receive(completion: .finished)
            self.sink = nil
        }
    }
}

#endif
