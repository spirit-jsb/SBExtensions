//
//  AssignOwnership.swift
//
//  Created by Max on 2024/1/26
//
//  Copyright © 2024 Max. All rights reserved.
//

#if canImport(Combine)

import Combine

public enum ObjectOwnership {
    case strong
    case weak
    case unowned
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publisher where Failure == Never {
    func assign<Root>(to keyPath: ReferenceWritableKeyPath<Root, Output>, on object: Root, ownership: ObjectOwnership) -> AnyCancellable where Root: AnyObject {
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
