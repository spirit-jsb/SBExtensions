//
//  PassthroughRelay.swift
//  SBExtensions
//
//  Created by 菅思博 on 2024/1/29.
//

#if canImport(Combine)

import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public class PassthroughRelay<Output>: Relay {
    private let subject: PassthroughSubject<Output, Never>
    
    private var subscriptions = [Subscription<PassthroughSubject<Output, Never>, AnySubscriber<Output, Never>>]()
    
    public init() {
        self.subject = PassthroughSubject()
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
    
    public func receive<S>(subscriber: S) where S : Subscriber, S.Input == Output, S.Failure == Never {
        let subscription = Subscription(upstream: self.subject, downstream: AnySubscriber(subscriber))
        
        self.subscriptions.append(subscription)
        
        subscriber.receive(subscription: subscription)
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
private extension PassthroughRelay {
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
            self.sink?.shouldForwardCompletion = true
            
            self.sink?.receive(completion: .finished)
            
            self.sink = nil
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
private extension PassthroughRelay {
    class Sink<Upstream, Downstream>: SBExtensions.Sink<Upstream, Downstream> where Upstream: Publisher, Downstream: Subscriber {
        var shouldForwardCompletion = false
        
        override func receive(completion: Subscribers.Completion<Upstream.Failure>) {
            guard self.shouldForwardCompletion else {
                return
            }
            
            super.receive(completion: completion)
        }
    }
}

#endif
