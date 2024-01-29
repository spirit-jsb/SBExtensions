//
//  ReplaySubject.swift
//
//  Created by Max on 2024/1/29
//
//  Copyright © 2024 Max. All rights reserved.
//

#if canImport(Combine)

import Combine
import class Foundation.NSRecursiveLock

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public final class ReplaySubject<Output, Failure>: Subject where Failure: Swift.Error {
    public typealias Output = Output
    public typealias Failure = Failure
    
    private(set) var subscriptions = [Subscription<AnySubscriber<Output, Failure>>]()
    
    private let bufferSize: Int
    
    private let lock = NSRecursiveLock()
    
    private var values = [Output]()
    private var completion: Subscribers.Completion<Failure>?
    
    private var isActive: Bool {
        return self.completion == nil
    }
    
    public init(bufferSize: Int) {
        self.bufferSize = bufferSize
    }
    
    public func send(_ value: Output) {
        let subscriptions: [Subscription<AnySubscriber<Output, Failure>>]
        
        do {
            self.lock.lock()
            defer {
                self.lock.unlock()
            }
            
            guard self.isActive else {
                return
            }
            
            self.values.append(value)
            if self.values.count > self.bufferSize {
                self.values.removeFirst()
            }
            
            subscriptions = self.subscriptions
        }
        
        subscriptions.forEach { $0.forwardValueToBuffer(value) }
    }
    
    public func send(completion: Subscribers.Completion<Failure>) {
        let subscriptions: [Subscription<AnySubscriber<Output, Failure>>]
        
        do {
            self.lock.lock()
            defer {
                self.lock.unlock()
            }
            
            guard self.isActive else {
                return
            }
            
            self.completion = completion
            
            subscriptions = self.subscriptions
        }
        
        subscriptions.forEach { $0.forwardCompletionToBuffer(completion) }
        
        self.lock.lock()
        defer {
            self.lock.unlock()
        }
        
        self.subscriptions.removeAll()
    }
    
    public func send(subscription: Combine.Subscription) {
        subscription.request(.unlimited)
    }
    
    public func receive<S>(subscriber: S) where S: Subscriber, S.Input == Output, S.Failure == Failure {
        let subscriberIdentifier = subscriber.combineIdentifier
        
        let subscription = Subscription(downstream: AnySubscriber(subscriber), cancellationHandler: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.completeSubscriber(withIdentifier: subscriberIdentifier)
        })
        
        do {
            self.lock.lock()
            defer {
                self.lock.unlock()
            }
            
            subscription.replay(self.values, completion: self.completion)
            
            self.subscriptions.append(subscription)
        }
        
        subscriber.receive(subscription: subscription)
    }
    
    private func completeSubscriber(withIdentifier subscriberIdentifier: CombineIdentifier) {
        self.lock.lock()
        defer {
            self.lock.unlock()
        }
        
        self.subscriptions.removeAll { $0.innerSubscriberIdentifier == subscriberIdentifier }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension ReplaySubject {
    final class Subscription<Downstream>: Combine.Subscription where Downstream: Subscriber, Downstream.Input == Output, Downstream.Failure == Failure {
        var description: String {
            return "ReplaySubject.Subscription<\(Output.self), \(Failure.self)>"
        }
        
        private var demandBuffer: DemandBuffer<Downstream>?
        private var cancellationHandler: (() -> Void)?
        
        fileprivate let innerSubscriberIdentifier: CombineIdentifier
        
        init(downstream: Downstream, cancellationHandler: (() -> Void)?) {
            self.demandBuffer = DemandBuffer(subscriber: downstream)
            self.innerSubscriberIdentifier = downstream.combineIdentifier
            
            self.cancellationHandler = cancellationHandler
        }
        
        func request(_ demand: Subscribers.Demand) {
            _ = self.demandBuffer?.demand(demand)
        }
        
        func cancel() {
            self.cancellationHandler?()
            self.cancellationHandler = nil
            
            self.demandBuffer = nil
        }
        
        func replay(_ values: [Output], completion: Subscribers.Completion<Failure>?) {
            values.forEach { self.forwardValueToBuffer($0) }
            
            if let completion = completion {
                self.forwardCompletionToBuffer(completion)
            }
        }
        
        func forwardValueToBuffer(_ value: Output) {
            _ = self.demandBuffer?.buffer(value: value)
        }
        
        func forwardCompletionToBuffer(_ completion: Subscribers.Completion<Failure>) {
            self.demandBuffer?.complete(completion: completion)
        }
    }
}

#endif

