//
//  CollectionExtensions.swift
//  SBExtensions
//
//  Created by JONO-Jsb on 2023/11/16.
//

public extension Collection {
    var fullRange: Range<Index> {
        return self.startIndex ..< self.endIndex
    }

    subscript(safe idx: Index) -> Element? {
        return self.indices.contains(idx) ? self[idx] : nil
    }
}
