//
//  CategoryDataProviderTests.swift
//  HangulTracingTests
//
//  Created by junwoo on 2017. 11. 22..
//  Copyright © 2017년 samchon. All rights reserved.
//

import XCTest
@testable import HangulTracing

class CategoryDataProviderTests: XCTestCase {
  var provider: CategoryDataProvider!
  var controller: CategoryVC!
  var collectionView: UICollectionView!
  
  override func setUp() {
    super.setUp()
    
    controller = CategoryVC()
    
    provider = CategoryDataProvider()
    provider.categoryManager = CategoryManager()
    _ = controller.view
    collectionView = controller.collectionView
    collectionView.dataSource = provider
    collectionView.delegate = provider
    collectionView.collectionViewLayout = UICollectionViewFlowLayout()
  }
  
  override func tearDown() {
    provider.categoryManager?.removeAll()
    super.tearDown()
  }
  
  func test_HasCellMode() {
    XCTAssertNotNil(provider.cellMode)
  }
  
  func test_numberOfItems_SameAsCategoriesCount() {
    let itemCount = collectionView.numberOfItems(inSection: 0)
    let categoryCount = provider.categoryManager?.categories.count
    XCTAssertEqual(itemCount, categoryCount)
  }
  
  func test_CellForItemAt_ReturnCategoryCell() {
    let newCategory = Category(category: "new")
    provider.categoryManager?.addCategory(newCategory: newCategory)
    
    collectionView.reloadData()
    controller.view.layoutIfNeeded()
    
    let cell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0))
    XCTAssertTrue(cell is CategoryCell)
    XCTAssertNotNil(cell)
  }
  
  func test_WhenCellForItemAt_DequeueCalled() {
    let mockCollectionView = MockCollectionView.mockCollectionView(provider)
    let newCategory = Category(category: "new")
    provider.categoryManager?.addCategory(newCategory: newCategory)
    mockCollectionView.reloadData()
    mockCollectionView.layoutIfNeeded()
    
    _ = mockCollectionView.cellForItem(at: IndexPath(item: 0, section: 0))
    XCTAssertTrue(mockCollectionView.dequeueIsCalled)
  }
  
  func test_WhenSelectingCell_PushCardListVC() {
    let mockNavigationController = MockNavigationController(rootViewController: controller)
    
    UIApplication.shared.keyWindow?.rootViewController = mockNavigationController
    provider.categoryManager?.addCategory(newCategory: Category(category: "동물"))
    collectionView.reloadData()
    controller.view.layoutIfNeeded()
    XCTAssertNotNil(collectionView.cellForItem(at: IndexPath(item: 0, section: 0)))
    collectionView.delegate?.collectionView!(collectionView, didSelectItemAt: IndexPath(item: 0, section: 0))
    
    XCTAssertTrue(mockNavigationController.pushedViewController is CardListVC)
  }
  
  func test_sizeForItemAt() {
    let newCategory = Category(category: "new")
    provider.categoryManager?.addCategory(newCategory: newCategory)
    
    collectionView.reloadData()
    controller.view.layoutIfNeeded()
    let sectionInsets = provider.sectionInsets
    let itemsPerRow = provider.itemsPerRow
    let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
    let availableWidth = UIScreen.main.bounds.width - paddingSpace
    let widthPerItem = availableWidth / itemsPerRow
    let cell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0))
    XCTAssertEqual(cell?.frame.size.height, widthPerItem)
    XCTAssertEqual(cell?.frame.size.width, widthPerItem)
  }
}

//dequeue 호출 확인하기 위해
extension CategoryDataProviderTests {
  
  class MockCollectionView: UICollectionView {
    
    var dequeueIsCalled: Bool = false
    
    override func dequeueReusableCell(withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionViewCell {
      dequeueIsCalled = true
      return super.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    }
    
    class func mockCollectionView(_ dataSource: UICollectionViewDataSource) -> MockCollectionView {
      
      let mockCollectionView = MockCollectionView(frame: CGRect(x: 0, y: 0, width: 300, height: 600), collectionViewLayout: UICollectionViewFlowLayout())
      
      mockCollectionView.dataSource = dataSource
      mockCollectionView.register(MockCell.self, forCellWithReuseIdentifier: "CategoryCell")
      
      return mockCollectionView
    }
  }
  
  class MockCell: CategoryCell {
    
  }
  
  class MockNavigationController: UINavigationController {
    var pushedViewController: UIViewController?
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
      pushedViewController = viewController
      super.pushViewController(viewController, animated: animated)
    }
  }
  
}
