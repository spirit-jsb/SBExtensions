//
//  RetryWithBehavior.swift
//  SBExtensions
//
//  Created by 菅思博 on 2024/1/30.
//

#if canImport(Combine)

import Combine
import Foundation

/// https://github.com/RxSwiftCommunity/RxSwiftExt/blob/main/Source/RxSwift/retryWithBehavior.swift

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public enum RepeatBehavior<S> where S: Scheduler {
    case immediate(maxCount: UInt)
    case delayed(maxCount: UInt, interval: TimeInterval)
    case exponentialDelayed(maxCount: UInt, interval: TimeInterval, multiplier: Double)
    case customTimerDelayed(maxCount: UInt, delayCalculator: (UInt) -> TimeInterval)
    
    func calculateConditions(_ currentRepetition: UInt) -> (maxCount: UInt, delay: S.SchedulerTimeType.Stride) {
        switch self {
            case .immediate(let maxCount):
                return (maxCount, .zero)
            case .delayed(let maxCount, let delay):
                return (maxCount, .milliseconds(Int(delay * 1000)))
            case .exponentialDelayed(let maxCount, let interval, let multiplier):
                let delay = currentRepetition == 1 ? interval : interval * pow(1 + multiplier, Double(currentRepetition - 1))
                
                return (maxCount, .milliseconds(Int(delay * 1000)))
            case .customTimerDelayed(let maxCount, let delayCalculator):
                return (maxCount, .seconds(delayCalculator(currentRepetition)))
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publisher {
    typealias RetryPredicate = (Error) -> Bool
    
    func retry<S>(_ behavior: RepeatBehavior<S>, scheduler: S, shouldRetry: RetryPredicate? = nil) -> AnyPublisher<Output, Failure> where S: Scheduler {
        return self.retry(1, behavior: behavior, scheduler: scheduler, shouldRetry: shouldRetry)
    }
    
    internal func retry<S>(_ currentAttempt: UInt, behavior: RepeatBehavior<S>, scheduler: S, shouldRetry: RetryPredicate?) -> AnyPublisher<Output, Failure> where S: Scheduler {
        guard currentAttempt > 0 else {
            return Empty().eraseToAnyPublisher()
        }
        
        let conditions = behavior.calculateConditions(currentAttempt)
        
        return self
            .catch { error -> AnyPublisher<Output, Failure> in
                if let shouldRetry = shouldRetry, !shouldRetry(error) {
                    return Fail(error: error).eraseToAnyPublisher()
                }
                
                guard currentAttempt <= conditions.maxCount else {
                    return Fail(error: error).eraseToAnyPublisher()
                }
                
                guard conditions.delay != .zero else {
                    return self.retry(currentAttempt + 1, behavior: behavior, scheduler: scheduler, shouldRetry: shouldRetry)
                }
                
                return Just(())
                    .setFailureType(to: Failure.self)
                    .delay(for: conditions.delay, scheduler: scheduler)
                    .flatMapLatest { self.retry(currentAttempt + 1, behavior: behavior, scheduler: scheduler, shouldRetry: shouldRetry).eraseToAnyPublisher() }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}

#endif
