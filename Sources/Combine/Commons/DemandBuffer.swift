//
//  DemandBuffer.swift
//
//  Created by Max on 2024/1/26
//
//  Copyright © 2024 Max. All rights reserved.
//

#if canImport(Combine)

import Combine
import class Foundation.NSRecursiveLock

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
class DemandBuffer<S> where S: Subscriber {
    var pendingDemand: Subscribers.Demand {
        self.lock.lock()
        defer {
            self.lock.unlock()
        }
        
        self.demandState.sent = self.demandState.requested
        return self.demandState.requested - self.demandState.processed
    }
    
    private let subscriber: S
    
    private let lock = NSRecursiveLock()
    
    private var completion: Subscribers.Completion<S.Failure>?
    
    private var demandState = DemandState()
    
    private var values = [S.Input]()
    
    init(subscriber: S) {
        self.subscriber = subscriber
    }
    
    func buffer(_ value: S.Input) -> Subscribers.Demand {
        precondition(self.completion == nil, "Completion have already occured.")
        
        self.lock.lock()
        defer {
            self.lock.unlock()
        }
        
        switch self.demandState.requested {
            case .unlimited:
                return self.subscriber.receive(value)
            default:
                self.values.append(value)
                
                return self.processDemand()
        }
    }
    
    func complete(completion: Subscribers.Completion<S.Failure>) {
        precondition(self.completion == nil, "Completion have already occured.")
        
        self.completion = completion
        
        _ = self.processDemand()
    }
    
    func demand(_ demand: Subscribers.Demand) -> Subscribers.Demand {
        return self.processDemand(demand)
    }
    
    private func processDemand(_ demand: Subscribers.Demand? = nil) -> Subscribers.Demand {
        self.lock.lock()
        defer {
            self.lock.unlock()
        }
        
        if let demand = demand {
            self.demandState.requested += demand
        }
        
        guard self.demandState.requested > 0 || demand == Subscribers.Demand.none else {
            return .none
        }
        
        while !self.values.isEmpty && self.demandState.processed < self.demandState.requested {
            self.demandState.requested += self.subscriber.receive(self.values.removeFirst())
            self.demandState.processed += 1
        }
        
        if let completion = self.completion {
            self.values = []
            
            self.demandState = DemandState()
            
            self.completion = nil
            
            self.subscriber.receive(completion: completion)
            
            return .none
        }
        
        let needSentDemand = self.demandState.requested - self.demandState.sent
        self.demandState.sent += needSentDemand
        
        return needSentDemand
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
private extension DemandBuffer {
    struct DemandState {
        var requested: Subscribers.Demand = .none
        var processed: Subscribers.Demand = .none
        var sent: Subscribers.Demand = .none
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Subscription {
    func requestIfNeeded(_ demand: Subscribers.Demand) {
        guard demand > .none else {
            return
        }
        
        self.request(demand)
    }
}

#endif
