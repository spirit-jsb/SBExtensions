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
    func retryWhen<TriggerPublisher>(_ notificationHandler: @escaping (AnyPublisher<Failure, Never>) -> TriggerPublisher) -> Publishers.RetryWhen<Self, TriggerPublisher, Output, Failure> where TriggerPublisher: Publisher {
        .init(upstream: self, notificationHandler: notificationHandler)
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publishers {
    class RetryWhen<Upstream, TriggerPublisher, Output, Failure>: Publisher where Upstream: Publisher, TriggerPublisher: Publisher, Upstream.Output == Output, Upstream.Failure == Failure {
        private let upstream: Upstream
        private let notificationHandler: (AnyPublisher<Upstream.Failure, Never>) -> TriggerPublisher

        init(upstream: Upstream, notificationHandler: @escaping (AnyPublisher<Upstream.Failure, Never>) -> TriggerPublisher) {
            self.upstream = upstream
            self.notificationHandler = notificationHandler
        }

        public func receive<S>(subscriber: S) where S: Subscriber, S.Input == Output, S.Failure == Failure {
            subscriber.receive(subscription: Subscription(upstream: self.upstream, downstream: subscriber, errorTrigger: self.errorTrigger))
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.RetryWhen {
    class Subscription<Downstream>: Combine.Subscription where Downstream: Subscriber, Downstream.Input == Output, Downstream.Failure == Failure {
        var description: String {
            return "RetryWhen.Subscription<\(Output.self), \(Failure.self)>"
        }

        private let upstream: Upstream
        private let downstream: Downstream

        private let errorSubject = PassthroughSubject<Failure, Never>()

        private var sink: Sink<Upstream, Downstream>?
        private var cancellable: AnyCancellable?

        init(upstream: Upstream, downstream: Downstream, notificationHandler: @escaping (AnyPublisher<Failure, Never>) -> TriggerPublisher) {
            self.upstream = upstream
            self.downstream = downstream

            self.sink = Sink(upstream: upstream, downstream: downstream, transformOutput: {
                $0
            }, transformFailure: { [errorSubject] in
                errorSubject.send($0)

                return nil
            })

            self.cancellable = notificationHandler(self.errorSubject.eraseToAnyPublisher())
                .sink(receiveCompletion: { [sink] completion in
                    switch completion {
                        case .finished:
                            sink?.buffer.complete(completion: .finished)
                        case let .failure(error):
                            if let error = error as? Failure {
                                sink?.buffer.complete(completion: .failure(error))
                            }
                    }
                }, receiveValue: { [upstream, sink] _ in
                    if let sink = sink {
                        upstream.subscribe(sink)
                    }
                })

            upstream.subscribe(self.sink!)
        }

        func request(_ demand: Subscribers.Demand) {
            self.sink?.demand(demand)
        }

        func cancel() {
            self.sink = nil
        }
    }
}

#endif
