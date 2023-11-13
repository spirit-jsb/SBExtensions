//
//  NSAttributedStringExtensions.swift
//  SBExtensions
//
//  Created by JONO-Jsb on 2023/11/13.
//

#if canImport(Foundation) && canImport(UIKit)

import Foundation
import UIKit

public extension NSAttributedString {
    var bolded: NSAttributedString {
        guard !self.string.isEmpty else {
            return self
        }

        let pointSize: CGFloat
        if let font = self.attribute(.font, at: 0, effectiveRange: nil) as? UIFont {
            pointSize = font.pointSize
        } else {
            pointSize = UIFont.systemFontSize
        }

        return self.applying(attributes: [.font: UIFont.boldSystemFont(ofSize: pointSize)])
    }

    var italicized: NSAttributedString {
        guard !self.string.isEmpty else {
            return self
        }

        let pointSize: CGFloat
        if let font = self.attribute(.font, at: 0, effectiveRange: nil) as? UIFont {
            pointSize = font.pointSize
        } else {
            pointSize = UIFont.systemFontSize
        }

        return self.applying(attributes: [.font: UIFont.italicSystemFont(ofSize: pointSize)])
    }

    var struckthrough: NSAttributedString {
        return self.applying(attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue])
    }

    var underlined: NSAttributedString {
        return self.applying(attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
    }

    var attributes: [NSAttributedString.Key: Any] {
        guard self.length > 0 else {
            return [:]
        }

        return self.attributes(at: 0, effectiveRange: nil)
    }
}

public extension NSAttributedString {
    static func + (lhs: NSAttributedString, rhs: NSAttributedString) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(attributedString: lhs)

        attributedString.append(rhs)

        return NSAttributedString(attributedString: attributedString)
    }

    static func += (lhs: inout NSAttributedString, rhs: NSAttributedString) {
        let attributedString = NSMutableAttributedString(attributedString: lhs)

        attributedString.append(rhs)

        lhs = attributedString
    }

    func colored(_ color: UIColor) -> NSAttributedString {
        return self.applying(attributes: [.foregroundColor: color])
    }

    func applying(attributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        guard !self.string.isEmpty else {
            return self
        }

        let attributedString = NSMutableAttributedString(attributedString: self)

        attributedString.addAttributes(attributes, range: NSRange(0 ..< self.length))

        return attributedString
    }

    func applying(attributes: [NSAttributedString.Key: Any], toRangesMatching pattern: String, options: NSRegularExpression.Options = []) -> NSAttributedString {
        guard let pattern = try? NSRegularExpression(pattern: pattern, options: options) else {
            return self
        }

        let matches = pattern.matches(in: self.string, options: [], range: NSRange(0 ..< self.length))

        let attributedString = NSMutableAttributedString(attributedString: self)

        for match in matches {
            attributedString.addAttributes(attributes, range: match.range)
        }

        return attributedString
    }

    func applying<T: StringProtocol>(attributes: [NSAttributedString.Key: Any], toOccurrencesOf target: T) -> NSAttributedString {
        return self.applying(attributes: attributes, toRangesMatching: "\\Q\(target)\\E")
    }
}

#endif
