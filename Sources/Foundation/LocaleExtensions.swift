//
//  LocaleExtensions.swift
//
//  Created by Max on 2023/11/18
//
//  Copyright © 2023 Max. All rights reserved.
//

#if canImport(Foundation)

import Foundation

public extension Locale {
    static var posix: Locale {
        return Locale(identifier: "en_US_POSIX")
    }
}

#endif
