//
//  Sink.swift
//
//  Created by Max on 2024/1/26
//
//  Copyright © 2024 Max. All rights reserved.
//

#if canImport(Combine)

import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
class Sink<Upstream, Downstream>: Subscriber where Upstream: Publisher, Downstream: Subscriber {
    typealias TransformOutput = (Upstream.Output) -> Downstream.Input?
    typealias TransformFailure = (Upstream.Failure) -> Downstream.Failure?
    
    private(set) var demandBuffer: DemandBuffer<Downstream>
    
    private let transformOutput: TransformOutput?
    private let transformFailure: TransformFailure?
    
    private var upstreamSubscription: Subscription?
    
    private var isUpstreamCancelled: Bool = false
    
    init(upstream: Upstream, downstream: Downstream, transformOutput: TransformOutput? = nil, transformFailure: TransformFailure? = nil) {
        self.demandBuffer = DemandBuffer(subscriber: downstream)
        
        self.transformOutput = transformOutput
        self.transformFailure = transformFailure
        
        upstream
            .handleEvents(receiveCancel: { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.isUpstreamCancelled = true
            })
            .subscribe(self)
    }
    
    deinit {
        self.cancelUpstream()
    }
    
    func receive(subscription: Subscription) {
        self.upstreamSubscription = subscription
    }
    
    func receive(_ input: Upstream.Output) -> Subscribers.Demand {
        guard let transform = self.transformOutput else {
            fatalError("""
                Missing output transformation
                =============================
                
                You must either:
                    - Provide a transformation function from the upstream's output to the downstream's input;
                    - Subclass `Sink` with your own publisher's Sink and manage the buffer yourself
                """)
        }
        
        guard let input = transform(input) else {
            return .none
        }
        
        return self.demandBuffer.enqueue(value: input)
    }
    
    func receive(completion: Subscribers.Completion<Upstream.Failure>) {
        switch completion {
            case .finished:
                self.demandBuffer.finish(with: .finished)
            case let .failure(error):
                guard let transform = self.transformFailure else {
                    fatalError("""
                        Missing failure transformation
                        ==============================
                        
                        You must either:
                            - Provide a transformation function from the upstream's failure to the downstream's failuer;
                            - Subclass `Sink` with your own publisher's Sink and manage the buffer yourself
                        """)
                }
                
                guard let error = transform(error) else {
                    return
                }
                
                self.demandBuffer.finish(with: .failure(error))
        }
        
        self.cancelUpstream()
    }
    
    func demand(_ demand: Subscribers.Demand) {
        let newDemand = self.demandBuffer.request(demand: demand)
        self.upstreamSubscription?.requestIfNeeded(newDemand)
    }
    
    func cancelUpstream() {
        guard !self.isUpstreamCancelled else {
            return
        }
        
        self.upstreamSubscription.kill()
    }
}

#endif
