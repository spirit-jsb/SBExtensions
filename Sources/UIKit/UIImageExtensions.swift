//
//  UIImageExtensions.swift
//
//  Created by Max on 2023/11/18
//
//  Copyright © 2023 Max. All rights reserved.
//

#if canImport(UIKit)

import UIKit

#if canImport(CoreImage)

import CoreImage

#endif

public extension UIImage {
    var original: UIImage {
        return self.withRenderingMode(.alwaysOriginal)
    }

    var template: UIImage {
        return self.withRenderingMode(.alwaysTemplate)
    }
}

public extension UIImage {
    static func downsample(imageAt imageURL: URL, to size: CGSize, scale: CGFloat) -> UIImage? {
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary

        guard let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, imageSourceOptions) else {
            return nil
        }

        let maxDimensionInPixels = max(size.width, size.height) * scale

        let downsampleOptions = [
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels,
            kCGImageSourceCreateThumbnailWithTransform: true,
        ] as [CFString: Any] as CFDictionary

        guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else {
            return nil
        }

        return UIImage(cgImage: downsampledImage)
    }

    #if canImport(CoreImage)

    func averageColor() -> UIColor? {
        // https://stackoverflow.com/questions/26330924
        guard let ciImage = self.ciImage ?? CIImage(image: self) else {
            return nil
        }

        // CIAreaAverage returns a single-pixel image that contains the average color for a given region of an image.
        let parameters = [kCIInputImageKey: ciImage, kCIInputExtentKey: CIVector(cgRect: ciImage.extent)]
        guard let outputImage = CIFilter(name: "CIAreaAverage", parameters: parameters)?.outputImage else {
            return nil
        }

        // After getting the single-pixel image from the filter extract pixel's RGBA8 data
        var bitmap = [UInt8](repeating: 0, count: 4)

        let workingColorSpace: Any = self.cgImage?.colorSpace ?? NSNull()

        let context = CIContext(options: [.workingColorSpace: workingColorSpace])

        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0), format: .RGBA8, colorSpace: nil)

        // Convert pixel data to UIColor
        return UIColor(red: CGFloat(bitmap[0]) / 225.0, green: CGFloat(bitmap[1]) / 225.0, blue: CGFloat(bitmap[2]) / 225.0, alpha: CGFloat(bitmap[3]) / 255.0)
    }

    #endif

    func compressed(quality: CGFloat = 0.8) -> UIImage? {
        guard let compressedData = self.jpegData(compressionQuality: quality) else {
            return nil
        }

        return UIImage(data: compressedData)
    }

    func compressedData(quality: CGFloat = 0.8) -> Data? {
        return self.jpegData(compressionQuality: quality)
    }

    func cropped(to rect: CGRect) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = self.scale

        return UIGraphicsImageRenderer(bounds: rect, format: format).image { context in
            self.draw(in: context.format.bounds)
        }
    }

    func resized(to size: CGSize) -> UIImage {
        let scaleFactor = min(size.width / self.size.width, size.height / self.size.height)

        let destSize = CGSize(width: self.size.width * scaleFactor, height: self.size.height * scaleFactor)

        let format = UIGraphicsImageRendererFormat()
        format.scale = 2.0

        return UIGraphicsImageRenderer(size: destSize, format: format).image { context in
            context.cgContext.interpolationQuality = .high
            context.cgContext.setShouldAntialias(true)
            context.cgContext.setAllowsAntialiasing(true)

            self.draw(in: context.format.bounds)
        }
    }

    func resized(toWidth width: CGFloat) -> UIImage {
        let scaleFactor = width / self.size.width

        let destSize = CGSize(width: width, height: self.size.height * scaleFactor)

        let format = UIGraphicsImageRendererFormat()
        format.scale = self.scale

        return UIGraphicsImageRenderer(size: destSize, format: format).image { context in
            self.draw(in: context.format.bounds)
        }
    }

    func resized(toHeight height: CGFloat) -> UIImage {
        let scaleFactor = height / self.size.height

        let destSize = CGSize(width: self.size.width * scaleFactor, height: height)

        let format = UIGraphicsImageRendererFormat()
        format.scale = self.scale

        return UIGraphicsImageRenderer(size: destSize, format: format).image { context in
            self.draw(in: context.format.bounds)
        }
    }

    func rotated(by radians: CGFloat) -> UIImage {
        let destRect = CGRect(origin: .zero, size: self.size).applying(CGAffineTransform(rotationAngle: radians))
        let roundedDestRect = CGRect(x: destRect.origin.x.rounded(), y: destRect.origin.y.rounded(), width: destRect.size.width.rounded(), height: destRect.size.height.rounded())

        let format = UIGraphicsImageRendererFormat()
        format.scale = self.scale

        return UIGraphicsImageRenderer(size: roundedDestRect.size, format: format).image { context in
            context.cgContext.translateBy(x: context.format.bounds.width / 2.0, y: context.format.bounds.height / 2.0)
            context.cgContext.rotate(by: radians)

            self.draw(in: CGRect(origin: CGPoint(x: -self.size.width / 2.0, y: -self.size.height / 2.0), size: self.size))
        }
    }

    func filled(withColor color: UIColor) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = self.scale

        return UIGraphicsImageRenderer(size: self.size, format: format).image { context in
            color.setFill()

            context.fill(context.format.bounds)
        }
    }

    func tint(_ color: UIColor, blendMode: CGBlendMode, alpha: CGFloat = 1.0) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = self.scale

        return UIGraphicsImageRenderer(size: self.size, format: format).image { context in
            color.setFill()

            context.fill(context.format.bounds)

            self.draw(in: context.format.bounds, blendMode: blendMode, alpha: alpha)
        }
    }

    func withBackgroundColor(_ backgroundColor: UIColor) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = self.scale

        return UIGraphicsImageRenderer(size: self.size, format: format).image { context in
            backgroundColor.setFill()

            context.fill(context.format.bounds)

            self.draw(in: .zero)
        }
    }

    func withRoundedCorners(radius: CGFloat? = nil) -> UIImage {
        let cornerRadius: CGFloat = radius != nil && radius! > 0.0 && radius! <= min(self.size.width, self.size.height) / 2.0 ? radius! : min(self.size.width, self.size.height) / 2.0

        let format = UIGraphicsImageRendererFormat()
        format.scale = self.scale

        return UIGraphicsImageRenderer(size: self.size, format: format).image { context in
            UIBezierPath(roundedRect: context.format.bounds, cornerRadius: cornerRadius).addClip()

            self.draw(in: context.format.bounds)
        }
    }
}

public extension UIImage {
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1.0, height: 1.0)) {
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1.0

        guard
            let cgImage = UIGraphicsImageRenderer(size: size, format: format).image(actions: { context in
                color.setFill()

                context.fill(context.format.bounds)
            }).cgImage else
        {
            return nil
        }

        self.init(cgImage: cgImage)
    }

    convenience init?(base64String: String, scale: CGFloat = 1.0) {
        guard let data = Data(base64Encoded: base64String) else {
            return nil
        }

        self.init(data: data, scale: scale)
    }
}

#endif
