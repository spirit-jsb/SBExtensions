//
//  RetryWhen.swift
//  SBExtensions
//
//  Created by Max on 2024/1/29.
//

#if canImport(Combine)

import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publisher {
    func retryWhen<RetryTrigger>(_ failureHandler: @escaping (AnyPublisher<Failure, Never>) -> RetryTrigger) -> Publishers.RetryWhen<Self, RetryTrigger, Output, Failure> where RetryTrigger: Publisher {
        .init(upstream: self, failureHandler: failureHandler)
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publishers {
    struct RetryWhen<Upstream, RetryTrigger, Output, Failure>: Publisher where Upstream: Publisher, RetryTrigger: Publisher, Upstream.Output == Output, Upstream.Failure == Failure {
        private let upstream: Upstream
        private let failureHandler: (AnyPublisher<Upstream.Failure, Never>) -> RetryTrigger
        
        init(upstream: Upstream, failureHandler: @escaping (AnyPublisher<Upstream.Failure, Never>) -> RetryTrigger) {
            self.upstream = upstream
            self.failureHandler = failureHandler
        }
        
        public func receive<S>(subscriber: S) where S: Subscriber, S.Input == Output, S.Failure == Failure {
            subscriber.receive(subscription: Subscription(upstream: self.upstream, downstream: subscriber, failureHandler: self.failureHandler))
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.RetryWhen {
    class Subscription<Downstream>: Combine.Subscription where Downstream: Subscriber, Downstream.Input == Upstream.Output, Downstream.Failure == Upstream.Failure {
        private let upstream: Upstream
        private let downstream: Downstream
        
        private let errorSubject = PassthroughSubject<Upstream.Failure, Never>()
        
        private var sink: Sink<Upstream, Downstream>?
        
        private var cancellable: AnyCancellable?
        
        init(upstream: Upstream, downstream: Downstream, failureHandler: @escaping (AnyPublisher<Upstream.Failure, Never>) -> RetryTrigger) {
            self.upstream = upstream
            self.downstream = downstream
            
            self.sink = Sink(upstream: upstream, downstream: downstream, transformOutput: {
                $0
            }, transformFailure: { [errorSubject] in
                errorSubject.send($0)
                
                return nil
            })
            
            self.cancellable = failureHandler(self.errorSubject.eraseToAnyPublisher())
                .sink(receiveCompletion: { [sink] completion in
                    switch completion {
                        case .finished:
                            sink?.demandBuffer.complete(completion: .finished)
                        case .failure(let error):
                            if let error = error as? Downstream.Failure {
                                sink?.demandBuffer.complete(completion: .failure(error))
                            }
                    }
                }, receiveValue: { [upstream, sink] _ in
                    if let sink = sink {
                        upstream.subscribe(sink)
                    }
                })
        }
        
        func request(_ demand: Subscribers.Demand) {
            self.sink?.request(demand)
        }
        
        func cancel() {
            self.cancellable?.cancel()
            self.cancellable = nil
            
            self.sink?.cancelUpstreamSubscription()
            self.sink = nil
        }
    }
}

#endif
