//
//  Runtime.swift
//
//  Created by Max on 2024/1/24
//
//  Copyright © 2024 Max. All rights reserved.
//

#if canImport(Foundation)

import Foundation

func getAssociatedObject<T>(_ object: Any, _ key: UnsafeRawPointer) -> T? {
    return objc_getAssociatedObject(object, key) as? T
}

func setAssociatedObject<T>(_ object: Any, _ key: UnsafeRawPointer, _ value: T) {
    objc_setAssociatedObject(object, key, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
}

#endif
