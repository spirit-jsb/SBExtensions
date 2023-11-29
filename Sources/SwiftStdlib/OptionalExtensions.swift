//
//  OptionalExtensions.swift
//
//  Created by Max on 2023/11/18
//
//  Copyright © 2023 Max. All rights reserved.
//

public extension Optional {
    var isNil: Bool {
        switch self {
            case .none:
                return true
            case .some:
                return false
        }
    }
}

public extension Optional where Wrapped: Collection {
    var isNilOrEmpty: Bool {
        switch self {
            case .none:
                return true
            case let .some(wrapped):
                return wrapped.isEmpty
        }
    }
}

public extension Optional where Wrapped: Numeric {
    var isNilOrZero: Bool {
        switch self {
            case .none:
                return true
            case let .some(wrapped):
                return wrapped == .zero
        }
    }
}

public extension Optional {
    mutating func appendOrInitialize<E>(_ newElement: Wrapped.Element) where Wrapped == [E] {
        self = self.appendedOrInitialized(newElement)
    }

    func appendedOrInitialized<E>(_ newElement: Wrapped.Element) -> Wrapped where Wrapped == [E] {
        return (self ?? []) + [newElement]
    }

    mutating func appendOrInitialize<S>(contentsOf newElements: S) where S: Sequence, Wrapped == [S.Element] {
        self = self.appendedOrInitialized(contentsOf: newElements)
    }

    func appendedOrInitialized<S>(contentsOf newElements: S) -> Wrapped where S: Sequence, Wrapped == [S.Element] {
        return (self ?? []) + newElements
    }
}
