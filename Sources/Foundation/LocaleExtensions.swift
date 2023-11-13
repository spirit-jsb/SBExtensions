//
//  LocaleExtensions.swift
//  SBExtensions
//
//  Created by JONO-Jsb on 2023/11/13.
//

#if canImport(Foundation)

import Foundation

public extension Locale {
    static var posix: Locale {
        return Locale(identifier: "en_US_POSIX")
    }
}

#endif
