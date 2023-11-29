//
//  BinaryFloatingPointExtensions.swift
//
//  Created by Max on 2023/11/18
//
//  Copyright © 2023 Max. All rights reserved.
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
