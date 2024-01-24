//
//  UICollectionViewExtensionsTests.swift
//
//  Created by Max on 2024/1/24
//
//  Copyright © 2024 Max. All rights reserved.
//

@testable import SBExtensions
import XCTest

#if canImport(UIKit)

private class TestableCollectionCell: UICollectionViewCell {}

private class TestableHeaderReusableView: UICollectionReusableView {}
private class TestableFooterReusableView: UICollectionReusableView {}

final class UICollectionViewExtensionsTests: XCTestCase {
    lazy var collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: UICollectionViewLayout())
    lazy var emptyCollectionView = UICollectionView(frame: CGRect(), collectionViewLayout: UICollectionViewLayout())

    override func setUp() {
        super.setUp()

        self.collectionView.dataSource = self
        self.collectionView.reloadData()

        self.emptyCollectionView.dataSource = self
        self.emptyCollectionView.reloadData()
    }

    func testLastItemIndexPath() {
        XCTAssertEqual(self.collectionView.lastItemIndexPath, IndexPath(item: 0, section: 1))
    }

    func testLastSection() {
        XCTAssertEqual(self.collectionView.lastSection, 1)
        XCTAssertEqual(self.emptyCollectionView.lastSection, 0)
    }

    func testNumberOfItems() {
        XCTAssertEqual(self.collectionView.numberOfItems, 5)
        XCTAssertEqual(self.emptyCollectionView.numberOfItems, 0)
    }

    func testRegisterCell() {
        let indexPath = IndexPath(item: 0, section: 0)

        self.collectionView.registerCell(TestableCollectionCell.self)

        XCTAssertNotNil(self.collectionView.dequeueReusableCell(TestableCollectionCell.self, at: indexPath))
    }
}

extension UICollectionViewExtensionsTests: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == self.collectionView ? section == 0 ? 5 : 0 : 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return collectionView == self.collectionView ? 2 : 0
    }
}

#endif
