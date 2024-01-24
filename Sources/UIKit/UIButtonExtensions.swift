//
//  UIButtonExtensions.swift
//
//  Created by Max on 2023/11/18
//
//  Copyright © 2023 Max. All rights reserved.
//

#if canImport(UIKit)

import UIKit

private struct AssociatedKeys {
    @UniqueAddress
    static var enlargedTouchArea
}

public extension UIButton {
    struct ImagePlacement: RawRepresentable {
        public static let top = ImagePlacement(rawValue: 1 << 0)
        public static let leading = ImagePlacement(rawValue: 1 << 1)
        public static let bottom = ImagePlacement(rawValue: 1 << 2)
        public static let trailing = ImagePlacement(rawValue: 1 << 3)

        public var rawValue: UInt

        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
    }
}

public extension UIButton {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard !self.isHidden || self.isEnabled || self.enlargedTouchArea != UIEdgeInsets.zero else {
            return super.point(inside: point, with: event)
        }

        let hitFrame = self.bounds.inset(by: self.enlargedTouchArea)

        return hitFrame.contains(point)
    }
}

public extension UIButton {
    var enlargedTouchArea: UIEdgeInsets {
        get {
            let enlargedTouchAreaValue: NSValue? = getAssociatedObject(self, AssociatedKeys.enlargedTouchArea)

            return enlargedTouchAreaValue.flatMap { $0.uiEdgeInsetsValue } ?? UIEdgeInsets.zero
        }
        set {
            setAssociatedObject(self, AssociatedKeys.enlargedTouchArea, NSValue(uiEdgeInsets: newValue))
        }
    }
}

public extension UIButton {
    private var states: [UIControl.State] {
        [.normal, .highlighted, .disabled, .selected, .focused]
    }

    func setTitleForStates(_ title: String?, states: [UIControl.State]) {
        states.forEach {
            self.setTitle(title, for: $0)
        }
    }

    func setTitleForAllStates(_ title: String?) {
        self.setTitleForStates(title, states: self.states)
    }

    func setTitleColorForStates(_ color: UIColor?, states: [UIControl.State]) {
        states.forEach {
            self.setTitleColor(color, for: $0)
        }
    }

    func setTitleColorForAllStates(_ color: UIColor?) {
        self.setTitleColorForStates(color, states: self.states)
    }

    func setImageForStates(_ image: UIImage?, states: [UIControl.State]) {
        states.forEach {
            self.setImage(image, for: $0)
        }
    }

    func setImageForAllStates(_ image: UIImage?) {
        self.setImageForStates(image, states: self.states)
    }

    func setBackgroundImageForStates(_ image: UIImage?, states: [UIControl.State]) {
        states.forEach {
            self.setBackgroundImage(image, for: $0)
        }
    }

    func setBackgroundImageForAllStates(_ image: UIImage?) {
        self.setBackgroundImageForStates(image, states: self.states)
    }

    func setAttributedTitleForStates(_ title: NSAttributedString?, states: [UIControl.State]) {
        states.forEach {
            self.setAttributedTitle(title, for: $0)
        }
    }

    func setAttributedTitleForAllStates(_ title: NSAttributedString?) {
        self.setAttributedTitleForStates(title, states: self.states)
    }

    func setBackgroundColor(_ color: UIColor?, for state: UIControl.State) {
        guard let color = color else {
            return
        }

        self.clipsToBounds = true

        let colorImage = UIGraphicsImageRenderer(size: CGSize(width: 1.0, height: 1.0)).image { context in
            color.setFill()

            context.fill(CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0))

            self.draw(CGRect.zero)
        }

        self.setBackgroundImage(colorImage, for: state)
    }

    func setBackgroundColorForStates(_ color: UIColor?, states: [UIControl.State]) {
        states.forEach {
            self.setBackgroundColor(color, for: $0)
        }
    }

    func setBackgroundColorForAllStates(_ color: UIColor?) {
        self.setBackgroundColorForStates(color, states: self.states)
    }

    func adjustTextImageLayout(imagePlacement: ImagePlacement, spacing: CGFloat) {
        guard let imageSize = self.imageView?.image?.size else {
            return
        }

        guard let font = self.titleLabel?.font, let titleSize = self.titleLabel?.text?.size(withAttributes: [.font: font]) else {
            return
        }

        var titleInsets = UIEdgeInsets.zero
        var imageInsets = UIEdgeInsets.zero
        var contentInsets = UIEdgeInsets.zero

        switch imagePlacement.rawValue {
            case ImagePlacement.top.rawValue:
                titleInsets = UIEdgeInsets(top: 0.0, left: -(imageSize.width), bottom: -(imageSize.height + spacing), right: 0.0)
                imageInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0.0, bottom: 0.0, right: -(titleSize.width))
                contentInsets = UIEdgeInsets(top: (titleSize.height + spacing) / 2.0, left: -(min(titleSize.width, imageSize.width) / 2.0), bottom: (imageSize.height + spacing) / 2.0, right: -(min(titleSize.width, imageSize.width) / 2.0))
            case ImagePlacement.leading.rawValue:
                titleInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: -spacing)
                imageInsets = UIEdgeInsets(top: 0.0, left: -spacing, bottom: 0.0, right: 0.0)
                contentInsets = UIEdgeInsets(top: 0.0, left: spacing / 2.0, bottom: 0.0, right: spacing / 2.0)
            case ImagePlacement.bottom.rawValue:
                titleInsets = UIEdgeInsets(top: -(imageSize.height + spacing), left: -(imageSize.width), bottom: 0.0, right: 0.0)
                imageInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: -(titleSize.height + spacing), right: -(titleSize.width))
                contentInsets = UIEdgeInsets(top: (titleSize.height + spacing) / 2.0, left: -(min(titleSize.width, imageSize.width) / 2.0), bottom: (imageSize.height + spacing) / 2.0, right: -(min(titleSize.width, imageSize.width) / 2.0))
            case ImagePlacement.trailing.rawValue:
                titleInsets = UIEdgeInsets(top: 0.0, left: -(2.0 * imageSize.width + spacing), bottom: 0.0, right: 0.0)
                imageInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: -(2.0 * titleSize.width + spacing))
                contentInsets = UIEdgeInsets(top: 0.0, left: spacing / 2.0, bottom: 0.0, right: spacing / 2.0)
            default:
                break
        }

        self.titleEdgeInsets = titleInsets
        self.imageEdgeInsets = imageInsets
        self.contentEdgeInsets = contentInsets
    }
}

#endif
