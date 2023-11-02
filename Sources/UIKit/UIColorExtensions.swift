//
//  UIColorExtensions.swift
//  SBExtensions
//
//  Created by JONO-Jsb on 2023/11/2.
//

#if canImport(UIKit)

import UIKit

public extension UIColor {
    static var random: UIColor {
        let red = Int.random(in: 0 ... 255)
        let green = Int.random(in: 0 ... 255)
        let blue = Int.random(in: 0 ... 255)

        return UIColor(red: red, green: green, blue: blue)!
    }
}

public extension UIColor {
    static func blend(_ color1: UIColor, _ color2: UIColor, blendFactor: CGFloat) -> UIColor? {
        var red1: CGFloat = 0.0, green1: CGFloat = 0.0, blue1: CGFloat = 0.0, alpha1: CGFloat = 0.0
        var red2: CGFloat = 0.0, green2: CGFloat = 0.0, blue2: CGFloat = 0.0, alpha2: CGFloat = 0.0

        // Get the RGBA components of colors
        if color1.getRed(&red1, green: &green1, blue: &blue1, alpha: &alpha1), color2.getRed(&red2, green: &green2, blue: &blue2, alpha: &alpha2) {
            // Calculate the blended RGBA components
            let blendedRed = (1.0 - blendFactor) * red1 + blendFactor * red2
            let blendedGreen = (1.0 - blendFactor) * green1 + blendFactor * green2
            let blendedBlue = (1.0 - blendFactor) * blue1 + blendFactor * blue2
            let blendedAlpha = (1.0 - blendFactor) * alpha1 + blendFactor * alpha2

            // Create and return the blended color
            return UIColor(red: blendedRed, green: blendedGreen, blue: blendedBlue, alpha: blendedAlpha)
        } else {
            // Failed to get the RGBA components of one or both colors, return nil
            return nil
        }
    }

    static func blend(_ color1: UIColor, _ color2: UIColor, blendMode: CGBlendMode) -> UIColor? {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue)

        var pixel: [UInt8] = [0, 0, 0, 0]

        if let context = CGContext(data: &pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) {
            context.setFillColor(color1.cgColor)
            context.fill(CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0))
            context.setBlendMode(blendMode)
            context.setFillColor(color2.cgColor)
            context.fill(CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0))
        }

        let blendedRed = Int(pixel[0])
        let blendedGreen = Int(pixel[1])
        let blendedBlue = Int(pixel[2])
        let blendedAlpha = CGFloat(pixel[3])

        return UIColor(red: blendedRed, green: blendedGreen, blue: blendedBlue, transparency: blendedAlpha)
    }

    func complementary() -> UIColor? {
        // Convert the provided color to the HSB color space
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        var alpha: CGFloat = 0.0

        if self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            // Calculate the complementary hue (180 degrees apart from the original hue)
            let complementaryHue = (hue + 0.5).truncatingRemainder(dividingBy: 1.0)

            // Create the complementary color using the modified HSB values
            return UIColor(hue: complementaryHue, saturation: saturation, brightness: brightness, alpha: alpha)
        } else {
            // Failed to get the HSB color space values, return nil
            return nil
        }
    }

    func lighten(byPercentage percentage: CGFloat) -> UIColor? {
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        var alpha: CGFloat = 0.0

        // Get the HSB components of the color
        if self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            // Calculate the new brightness value
            let lightenBrightness = max(min(brightness + percentage, 1.0), 0.0)

            // Create and return the new lightened color with the updated brightness value
            return UIColor(hue: hue, saturation: saturation, brightness: lightenBrightness, alpha: alpha)
        } else {
            // Failed to get the HSB color space values, return nil
            return nil
        }
    }

    func darken(byPercentage percentage: CGFloat) -> UIColor? {
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        var alpha: CGFloat = 0.0

        // Get the HSB components of the color
        if self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            // Calculate the new brightness value
            let darkenBrightness = max(min(brightness - percentage, 1.0), 0.0)

            // Create and return the new lightened color with the updated brightness value
            return UIColor(hue: hue, saturation: saturation, brightness: darkenBrightness, alpha: alpha)
        } else {
            // Failed to get the HSB color space values, return nil
            return nil
        }
    }
}

public extension UIColor {
    convenience init(light: UIColor, dark: UIColor) {
        if #available(iOS 13.0, *) {
            self.init(dynamicProvider: { $0.userInterfaceStyle == .dark ? dark : light })
        } else {
            self.init(cgColor: light.cgColor)
        }
    }

    convenience init?(hexString: String, transparency: CGFloat = 1.0) {
        var hexString = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted).lowercased()

        if hexString.hasPrefix("0x") {
            hexString = hexString.replacingOccurrences(of: "0x", with: "")
        }

        // convert hex to 6 digit format if in short format
        if hexString.count == 3 {
            hexString = hexString.map { String(repeating: $0, count: 2) }.joined()
        }

        guard let hex = Int(hexString, radix: 16) else {
            return nil
        }

        self.init(hex: hex, transparency: transparency)
    }

    convenience init?(hex: Int, transparency: CGFloat = 1.0) {
        let red = (hex >> 16) & 0xFF
        let green = (hex >> 8) & 0xFF
        let blue = hex & 0xFF

        self.init(red: red, green: green, blue: blue, transparency: transparency)
    }

    convenience init?(red: Int, green: Int, blue: Int, transparency: CGFloat = 1.0) {
        guard red >= 0, red <= 255 else {
            return nil
        }
        guard green >= 0, green <= 255 else {
            return nil
        }
        guard blue >= 0, blue <= 255 else {
            return nil
        }

        let red = CGFloat(red) / 255.0
        let green = CGFloat(green) / 255.0
        let blue = CGFloat(blue) / 255.0
        let alpha = transparency < 0.0 ? 0.0 : transparency > 1.0 ? 1.0 : transparency

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

#endif
