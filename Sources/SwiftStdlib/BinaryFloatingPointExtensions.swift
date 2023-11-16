//
//  BinaryFloatingPointExtensions.swift
//  SBExtensions
//
//  Created by JONO-Jsb on 2023/11/16.
//

#if canImport(Foundation)

import Foundation

#endif

public extension BinaryFloatingPoint {
    #if canImport(Foundation)

    func rounded(to numberOfDecimalPlaces: Int, rule: FloatingPointRoundingRule) -> Self {
        let factor = Self(pow(10.0, Double(max(numberOfDecimalPlaces, 0))))

        return (self * factor).rounded(rule) / factor
    }

    #endif
}
