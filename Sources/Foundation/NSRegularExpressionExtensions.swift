//
//  NSRegularExpressionExtensions.swift
//  SBExtensions
//
//  Created by JONO-Jsb on 2023/11/15.
//

#if canImport(Foundation)

import Foundation

public extension NSRegularExpression {
    func enumerateMatches(in string: String, options: NSRegularExpression.MatchingOptions = [], range: Range<String.Index>, using block: (_: NSTextCheckingResult?, _: NSRegularExpression.MatchingFlags, _: inout Bool) -> Void) {
        self.enumerateMatches(in: string, options: options, range: NSRange(range, in: string)) { result, flags, stop in
            var shouldStop = false

            block(result, flags, &shouldStop)

            if shouldStop {
                stop.pointee = true
            }
        }
    }

    func matches(in string: String, options: NSRegularExpression.MatchingOptions = [], range: Range<String.Index>) -> [NSTextCheckingResult] {
        return self.matches(in: string, options: options, range: NSRange(range, in: string))
    }

    func numberOfMatches(in string: String, options: NSRegularExpression.MatchingOptions = [], range: Range<String.Index>) -> Int {
        return self.numberOfMatches(in: string, options: options, range: NSRange(range, in: string))
    }

    func firstMatch(in string: String, options: NSRegularExpression.MatchingOptions = [], range: Range<String.Index>) -> NSTextCheckingResult? {
        return self.firstMatch(in: string, options: options, range: NSRange(range, in: string))
    }

    func rangeOfFirstMatch(in string: String, options: NSRegularExpression.MatchingOptions = [], range: Range<String.Index>) -> Range<String.Index>? {
        return Range(self.rangeOfFirstMatch(in: string, options: options, range: NSRange(range, in: string)), in: string)
    }

    func stringByReplacingMatches(in string: String, options: NSRegularExpression.MatchingOptions = [], range: Range<String.Index>, withTemplate templ: String) -> String {
        return self.stringByReplacingMatches(in: string, options: options, range: NSRange(range, in: string), withTemplate: templ)
    }

    @discardableResult
    func replaceMatches(in string: inout String, options: NSRegularExpression.MatchingOptions = [], range: Range<String.Index>, withTemplate templ: String) -> Int {
        let mutableString = NSMutableString(string: string)

        let matches = self.replaceMatches(in: mutableString, options: options, range: NSRange(range, in: string), withTemplate: templ)

        string = mutableString.copy() as! String

        return matches
    }
}

#endif
