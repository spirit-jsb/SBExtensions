//
//  AssignToMany.swift
//
//  Created by Max on 2024/1/26
//
//  Copyright © 2024 Max. All rights reserved.
//

#if canImport(Combine)

import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publisher where Failure == Never {
    func assign<Root1, Root2>(to keyPath1: ReferenceWritableKeyPath<Root1, Output>, on object1: Root1, and keyPath2: ReferenceWritableKeyPath<Root2, Output>, on object2: Root2) -> AnyCancellable {
        return self.sink { value in
            object1[keyPath: keyPath1] = value
            object2[keyPath: keyPath2] = value
        }
    }
    
    func assign<Root1, Root2, Root3>(to keyPath1: ReferenceWritableKeyPath<Root1, Output>, on object1: Root1, and keyPath2: ReferenceWritableKeyPath<Root2, Output>, on object2: Root2, and keyPath3: ReferenceWritableKeyPath<Root3, Output>, on object3: Root3) -> AnyCancellable {
        return self.sink { value in
            object1[keyPath: keyPath1] = value
            object2[keyPath: keyPath2] = value
            object3[keyPath: keyPath3] = value
        }
    }
}

#endif
