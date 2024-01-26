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
    private let subscriber: S

    private let lock = NSRecursiveLock()

    private var completion: Subscribers.Completion<S.Failure>?

    private var buffer = [S.Input]()
    private var demandState = DemandState()

    init(subscriber: S) {
        self.subscriber = subscriber
    }

    func buffer(value: S.Input) -> Subscribers.Demand {
        precondition(self.completion == nil, "Completion have already occured.")

        self.lock.lock()
        defer {
            self.lock.unlock()
        }

        switch self.demandState.requested {
            case .unlimited:
                return self.subscriber.receive(value)
            default:
                self.buffer.append(value)

                return self.flush()
        }
    }

    func demand(_ demand: Subscribers.Demand) -> Subscribers.Demand {
        return self.flush(adding: demand)
    }

    func complete(completion: Subscribers.Completion<S.Failure>) {
        precondition(self.completion == nil, "Completion have already occured.")

        self.completion = completion

        _ = self.flush()
    }

    private func flush(adding newDemand: Subscribers.Demand? = nil) -> Subscribers.Demand {
        self.lock.lock()
        defer {
            self.lock.unlock()
        }

        if let newDemand = newDemand {
            self.demandState.requested += newDemand
        }

        guard self.demandState.requested > 0 || newDemand == Subscribers.Demand.none else {
            return .none
        }

        while !self.buffer.isEmpty && self.demandState.processed < self.demandState.requested {
            self.demandState.requested += self.subscriber.receive(self.buffer.remove(at: 0))
            self.demandState.processed += 1
        }

        if let completion = self.completion {
            self.buffer = []
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

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Optional where Wrapped == Subscription {
    mutating func kill() {
        self?.cancel()
        self = nil
    }
}

#endif
