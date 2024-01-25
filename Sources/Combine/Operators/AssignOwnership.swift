//
//  AssignOwnership.swift
//  SBExtensions
//
//  Created by 菅思博 on 2024/1/25.
//

#if canImport(Combine)

import Combine

public enum ObjectOwnership {
    case strong
    case weak
    case unowned
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publisher where Self.Failure == Never {
    func assign<Root>(to keyPath: ReferenceWritableKeyPath<Root, Self.Output>, on object: Root, ownership: ObjectOwnership) -> AnyCancellable where Root: AnyObject {
        switch ownership {
            case .strong:
                return self.assign(to: keyPath, on: object)
            case .weak:
                return self.sink { [weak object] value in
                    object?[keyPath: keyPath] = value
                }
            case .unowned:
                return self.sink { [unowned object] value in
                    object[keyPath: keyPath] = value
                }
        }
    }
}

#endif
