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
    func retryWhen<TriggerPublisher>(_ failureHandler: @escaping (AnyPublisher<Failure, Never>) -> TriggerPublisher) -> Publishers.RetryWhen<Self, TriggerPublisher, Output, Failure> where TriggerPublisher: Publisher {
        .init(upstream: self, failureHandler: failureHandler)
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publishers {
    class RetryWhen<Upstream, TriggerPublisher, Output, Failure>: Publisher where Upstream: Publisher, TriggerPublisher: Publisher, Upstream.Output == Output, Upstream.Failure == Failure {
        private let upstream: Upstream
        private let failureHandler: (AnyPublisher<Upstream.Failure, Never>) -> TriggerPublisher

        init(upstream: Upstream, failureHandler: @escaping (AnyPublisher<Upstream.Failure, Never>) -> TriggerPublisher) {
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
        var description: String {
            return "RetryWhen.Subscription<\(Output.self), \(Failure.self)>"
        }

        private let upstream: Upstream
        private let downstream: Downstream

        private let errorSubject = PassthroughSubject<Upstream.Failure, Never>()

        private var sink: Sink<Upstream, Downstream>?
        private var cancellable: AnyCancellable?

        init(upstream: Upstream, downstream: Downstream, failureHandler: @escaping (AnyPublisher<Upstream.Failure, Never>) -> TriggerPublisher) {
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
                            sink?.buffer.complete(completion: .finished)
                        case .failure(let error):
                            if let error = error as? Downstream.Failure {
                                sink?.buffer.complete(completion: .failure(error))
                            }
                    }
                }, receiveValue: { [upstream, sink] _ in
//                    if let sink = sink {
//                        upstream.subscribe(sink)
//                    }
                })
        }

        func request(_ demand: Subscribers.Demand) {
            self.sink?.demand(demand)
        }

        func cancel() {
            self.cancellable?.cancel()
            self.cancellable = nil
            
            self.sink?.cancelUpstream()
            self.sink = nil
        }
    }
}

#endif
