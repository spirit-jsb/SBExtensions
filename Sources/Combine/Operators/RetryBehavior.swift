//
//  RetryBehavior.swift
//  SBExtensions
//
//  Created by 菅思博 on 2024/1/31.
//

#if canImport(Combine)

import Combine
import Foundation

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public enum RetryStrategy<S> where S: Scheduler {
    case immediate(maxCount: UInt)
    case delayed(maxCount: UInt, interval: TimeInterval)
    case exponentialDelayed(maxCount: UInt, interval: TimeInterval, multiplier: Double)
    case customTimerDelayed(maxCount: UInt, delayCalculator: (UInt) -> TimeInterval)
    
    func calculateConditions(_ currentRetryCount: UInt) -> (maxCount: UInt, delay: S.SchedulerTimeType.Stride) {
        switch self {
            case .immediate(let maxCount):
                return (maxCount, .zero)
            case .delayed(let maxCount, let delay):
                return (maxCount, .milliseconds(Int(delay * 1000)))
            case .exponentialDelayed(let maxCount, let interval, let multiplier):
                let delay = currentRetryCount == 1 ? interval : interval * pow(1 + multiplier, Double(currentRetryCount - 1))
                return (maxCount, .milliseconds(Int(delay * 1000)))
            case .customTimerDelayed(let maxCount, let delayCalculator):
                return (maxCount, .seconds(delayCalculator(currentRetryCount)))
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publisher {
    typealias RetryPredicate = (Error) -> Bool
    
    func retry<S>(_ strategy: RetryStrategy<S>, scheduler: S, shouldRetry: RetryPredicate? = nil) -> AnyPublisher<Output, Failure> where S: Scheduler {
        return self.retry(1, strategy: strategy, scheduler: scheduler, shouldRetry: shouldRetry)
    }
    
    internal func retry<S>(_ currentRetryCount: UInt, strategy: RetryStrategy<S>, scheduler: S, shouldRetry: RetryPredicate?) -> AnyPublisher<Output, Failure> where S: Scheduler {
        guard currentRetryCount > 0 else {
            return Empty().eraseToAnyPublisher()
        }
        
        let conditions = strategy.calculateConditions(currentRetryCount)
        
        return self
            .catch { error -> AnyPublisher<Output, Failure> in
                guard shouldRetry?(error) != false else {
                    return Fail(error: error).eraseToAnyPublisher()
                }
                
                guard currentRetryCount <= conditions.maxCount else {
                    return Fail(error: error).eraseToAnyPublisher()
                }
                
                return Just(())
                    .setFailureType(to: Failure.self)
                    .delay(for: conditions.delay, scheduler: scheduler)
                    .flatMapLatest { self.retry(currentRetryCount + 1, strategy: strategy, scheduler: scheduler, shouldRetry: shouldRetry) }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}

#endif
