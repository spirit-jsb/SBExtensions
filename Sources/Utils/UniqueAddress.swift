//
//  UniqueAddress.swift
//  SBExtensions
//
//  Created by 菅思博 on 2024/1/24.
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
