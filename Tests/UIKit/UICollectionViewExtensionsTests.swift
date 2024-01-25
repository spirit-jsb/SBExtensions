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

    lazy var flowLayoutCollectionView: UICollectionView = {
        let collectionViewLayout: UICollectionViewFlowLayout = {
            let collectionViewLayout = UICollectionViewFlowLayout()
            collectionViewLayout.minimumInteritemSpacing = 0.0
            collectionViewLayout.itemSize = CGSize(width: 10.0, height: 10.0)
            collectionViewLayout.sectionInset = UIEdgeInsets.zero
            
            return collectionViewLayout
        }()
        
        let collectionView = UICollectionView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 15.0), collectionViewLayout: collectionViewLayout)
        
        return collectionView
    }()
    
    override func setUp() {
        super.setUp()

        self.collectionView.dataSource = self
        self.collectionView.reloadData()

        self.emptyCollectionView.dataSource = self
        self.emptyCollectionView.reloadData()
        
        self.flowLayoutCollectionView.dataSource = self
        self.flowLayoutCollectionView.reloadData()
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
    
    func testRegisterSupplementaryView() {
        let indexPath = IndexPath()
        
        self.collectionView.registerSupplementaryView(TestableHeaderReusableView.self, supplementaryViewKind: .header)
        self.collectionView.registerSupplementaryView(TestableFooterReusableView.self, supplementaryViewKind: .footer)
        
        XCTAssertNotNil(self.collectionView.dequeueReusableSupplementaryView(TestableHeaderReusableView.self, supplementaryViewKind: .header, at: indexPath))
        XCTAssertNotNil(self.collectionView.dequeueReusableSupplementaryView(TestableFooterReusableView.self, supplementaryViewKind: .footer, at: indexPath))
    }
    
    func testIndexPathOfLastItem() {
        XCTAssertNil(self.collectionView.indexPathOfLastItem(inSection: -1))
        XCTAssertNil(self.collectionView.indexPathOfLastItem(inSection: 2))
        XCTAssertEqual(self.collectionView.indexPathOfLastItem(inSection: 0), IndexPath(item: 4, section: 0))
    }
    
    func testSafeScrollToItem() {
        let validTopIndexPath = IndexPath(item: 0, section: 0)
        
        self.flowLayoutCollectionView.contentOffset = CGPoint(x: 0.0, y: 20.0)
        
        XCTAssertNotEqual(self.flowLayoutCollectionView.contentOffset, CGPoint.zero)
        
        self.flowLayoutCollectionView.safeScrollToItem(at: validTopIndexPath, at: .top, animated: false)
        
        XCTAssertEqual(self.flowLayoutCollectionView.contentOffset, CGPoint.zero)
        
        let validBottomIndexPath = IndexPath(item: 4, section: 0)
        let bottomOffset = CGPoint(x: 0.0, y: self.flowLayoutCollectionView.collectionViewLayout.collectionViewContentSize.height - self.flowLayoutCollectionView.bounds.size.height)
        
        XCTAssertNotEqual(self.flowLayoutCollectionView.contentOffset, bottomOffset)
        
        self.flowLayoutCollectionView.safeScrollToItem(at: validBottomIndexPath, at: .bottom, animated: false)
        
        XCTAssertEqual(self.flowLayoutCollectionView.contentOffset, bottomOffset)
        
        let invalidIndexPath = IndexPath(item: 1, section: 2)
        
        self.flowLayoutCollectionView.contentOffset = CGPoint.zero
        
        self.flowLayoutCollectionView.safeScrollToItem(at: invalidIndexPath, at: .bottom, animated: false)
        
        XCTAssertEqual(self.flowLayoutCollectionView.contentOffset, CGPoint.zero)
        
        let negativeIndexPath = IndexPath(item: -1, section: 0)
        
        self.flowLayoutCollectionView.safeScrollToItem(at: negativeIndexPath, at: .bottom, animated: false)
        
        XCTAssertEqual(self.flowLayoutCollectionView.contentOffset, CGPoint.zero)
    }
}

extension UICollectionViewExtensionsTests: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (collectionView == self.collectionView || collectionView == self.flowLayoutCollectionView) ? section == 0 ? 5 : 0 : 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return (collectionView == self.collectionView || collectionView == self.flowLayoutCollectionView) ? 2 : 0
    }
}

#endif
