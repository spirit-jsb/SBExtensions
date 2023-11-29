//
//  UIScrollViewExtensions.swift
//
//  Created by Max on 2023/11/2
//
//  Copyright © 2023 Max. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public extension UIScrollView {
    var visiableRect: CGRect {
        let visiableX = self.contentOffset.x
        let visiableY = self.contentOffset.y
        let visiableWidth = min(min(self.bounds.width, self.contentSize.width), self.contentSize.width - self.contentOffset.x)
        let visiableHeight = min(min(self.bounds.height, self.contentSize.height), self.contentSize.height - self.contentOffset.y)

        return CGRect(x: visiableX, y: visiableY, width: visiableWidth, height: visiableHeight)
    }
}

public extension UIScrollView {
    func scrollToLeft(animated: Bool) {
        self.setContentOffset(CGPoint(x: -self.contentInset.left, y: self.contentOffset.y), animated: animated)
    }

    func scrollToTop(animated: Bool) {
        self.setContentOffset(CGPoint(x: self.contentOffset.x, y: -self.contentInset.top), animated: animated)
    }

    func scrollToRight(animated: Bool) {
        self.setContentOffset(CGPoint(x: max(self.contentSize.width - self.bounds.width, 0.0) + self.contentInset.right, y: self.contentOffset.y), animated: animated)
    }

    func scrollToBottom(animated: Bool) {
        self.setContentOffset(CGPoint(x: self.contentOffset.x, y: max(self.contentSize.height - self.bounds.height, 0.0) + self.contentInset.bottom), animated: animated)
    }

    func scrollToLeftPage(animated: Bool) {
        let minX = -self.contentInset.left

        var x = max(self.contentOffset.x - self.bounds.width, minX)

        if self.isPagingEnabled, self.bounds.width != 0.0 {
            let page = max(((x + self.contentInset.left) / self.bounds.width).rounded(.down), 0)

            x = max(page * self.bounds.width - self.contentInset.left, minX)
        }

        self.setContentOffset(CGPoint(x: x, y: self.contentOffset.y), animated: animated)
    }

    func scrollToUpPage(animated: Bool) {
        let minY = -self.contentInset.top

        var y = max(self.contentOffset.y - self.bounds.height, minY)

        if self.isPagingEnabled, self.bounds.height != 0.0 {
            let page = max(((y + self.contentInset.top) / self.bounds.height).rounded(.down), 0)

            y = max(page * self.bounds.height - self.contentInset.top, minY)
        }

        self.setContentOffset(CGPoint(x: self.contentOffset.x, y: y), animated: animated)
    }

    func scrollToRightPage(animated: Bool) {
        let maxX = max(self.contentSize.width - self.bounds.width, 0.0) + self.contentInset.right

        var x = min(self.contentOffset.x + self.bounds.width, maxX)

        if self.isPagingEnabled, self.bounds.width != 0.0 {
            let page = ((x + self.contentInset.left) / self.bounds.width).rounded(.down)

            x = min(page * self.bounds.width - self.contentInset.left, maxX)
        }

        self.setContentOffset(CGPoint(x: x, y: self.contentOffset.y), animated: animated)
    }

    func scrollToDownPage(animated: Bool) {
        let maxY = max(self.contentSize.height - self.bounds.height, 0.0) + self.contentInset.bottom

        var y = min(self.contentOffset.y + self.bounds.height, maxY)

        if self.isPagingEnabled, self.bounds.height != 0.0 {
            let page = ((y + self.contentInset.top) / self.bounds.height).rounded(.down)

            y = min(page * self.bounds.height - self.contentInset.top, maxY)
        }

        self.setContentOffset(CGPoint(x: self.contentOffset.x, y: y), animated: animated)
    }
}

#endif
