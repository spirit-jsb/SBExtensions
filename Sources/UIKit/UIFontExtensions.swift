//
//  UIFontExtensions.swift
//  SBExtensions
//
//  Created by JONO-Jsb on 2023/11/2.
//

#if canImport(UIKit)

import UIKit

public extension UIFont {
    static func loadFontFromURL(_ url: URL) throws {
        var errorRef: Unmanaged<CFError>?

        let result = CTFontManagerRegisterFontsForURL(url as CFURL, .process, &errorRef)

        if !result, let error = errorRef?.takeRetainedValue() {
            throw error
        }
    }

    static func unloadFontFromURL(_ url: URL) {
        _ = CTFontManagerUnregisterFontsForURL(url as CFURL, .none, nil)
    }

    static func loadFontFromData(_ data: Data) -> UIFont? {
        guard let provider = CGDataProvider(data: data as CFData) else {
            return nil
        }

        guard let font = CGFont(provider), CTFontManagerRegisterGraphicsFont(font, nil), let fontName = font.postScriptName else {
            return nil
        }

        return UIFont(name: fontName as String, size: UIFont.systemFontSize)
    }

    static func unloadFont(_ font: UIFont) {
        guard let font = CGFont(font.fontName as CFString) else {
            return
        }
        _ = CTFontManagerUnregisterGraphicsFont(font, nil)
    }

    func normal() -> UIFont {
        return UIFont(descriptor: self.fontDescriptor.withSymbolicTraits(.init(rawValue: 0))!, size: self.pointSize)
    }

    func bold() -> UIFont {
        return UIFont(descriptor: self.fontDescriptor.withSymbolicTraits(.traitBold)!, size: self.pointSize)
    }

    func italic() -> UIFont {
        return UIFont(descriptor: self.fontDescriptor.withSymbolicTraits(.traitItalic)!, size: self.pointSize)
    }

    func boldItalic() -> UIFont {
        return UIFont(descriptor: self.fontDescriptor.withSymbolicTraits([.traitBold, .traitItalic])!, size: self.pointSize)
    }

    func monospaced() -> UIFont {
        let featureSettings: [[UIFontDescriptor.FeatureKey: Int]]
        if #available(iOS 15.0, *) {
            featureSettings = [[.type: kNumberSpacingType, .selector: kMonospacedNumbersSelector]]
        } else {
            featureSettings = [[.featureIdentifier: kNumberSpacingType, .typeIdentifier: kMonospacedNumbersSelector]]
        }

        return UIFont(descriptor: self.fontDescriptor.addingAttributes([.featureSettings: featureSettings]), size: self.pointSize)
    }
}

#endif
