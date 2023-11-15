//
//  NSPredicateExtensions.swift
//  SBExtensions
//
//  Created by JONO-Jsb on 2023/11/15.
//

#if canImport(Foundation)

import Foundation

public extension NSPredicate {
    var not: NSCompoundPredicate {
        return NSCompoundPredicate(notPredicateWithSubpredicate: self)
    }
}

public extension NSPredicate {
    static prefix func ! (rhs: NSPredicate) -> NSCompoundPredicate {
        return rhs.not
    }

    static func + (lhs: NSPredicate, rhs: NSPredicate) -> NSCompoundPredicate {
        return lhs.and(rhs)
    }

    static func | (lhs: NSPredicate, rhs: NSPredicate) -> NSCompoundPredicate {
        return lhs.or(rhs)
    }

    static func - (lhs: NSPredicate, rhs: NSPredicate) -> NSCompoundPredicate {
        return lhs + !rhs
    }

    func and(_ predicate: NSPredicate) -> NSCompoundPredicate {
        return NSCompoundPredicate(andPredicateWithSubpredicates: [self, predicate])
    }

    func or(_ predicate: NSPredicate) -> NSCompoundPredicate {
        return NSCompoundPredicate(orPredicateWithSubpredicates: [self, predicate])
    }
}

#endif
