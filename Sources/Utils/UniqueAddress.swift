//
//  UniqueAddress.swift
//
//  Created by Max on 2024/1/24
//
//  Copyright © 2024 Max. All rights reserved.
//

#if canImport(Foundation)

import Foundation

@propertyWrapper
class UniqueAddress {
    var wrappedValue: UnsafeRawPointer {
        return UnsafeRawPointer(Unmanaged.passUnretained(self).toOpaque())
    }
    
    init() {
        
    }
}

#endif
