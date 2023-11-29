//
//  CollectionExtensions.swift
//
//  Created by Max on 2023/11/18
//
//  Copyright © 2023 Max. All rights reserved.
//

public extension Collection {
    var fullRange: Range<Index> {
        return self.startIndex ..< self.endIndex
    }

    subscript(safe idx: Index) -> Element? {
        return self.indices.contains(idx) ? self[idx] : nil
    }
}
