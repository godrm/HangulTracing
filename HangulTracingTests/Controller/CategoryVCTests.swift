//
//  CategoryVCTests.swift
//  HangulTracingTests
//
//  Created by junwoo on 2017. 11. 22..
//  Copyright © 2017년 samchon. All rights reserved.
//

import XCTest
@testable import HangulTracing

class CategoryVCTests: XCTestCase {
  
  var sut: CategoryVC!
  
  override func setUp() {
    super.setUp()
    sut = CategoryVC()
    _ = sut.view
  }
  
  override func tearDown() {
    sut.categoryManager.removeAll()
    super.tearDown()
  }
  
  func test_HasCategoryManager() {
    XCTAssertNotNil(sut.categoryManager)
  }
  
  func test_HasCategoryDataProvider() {
    XCTAssertNotNil(sut.categoryDataProvider)
  }
  
  func test_HasCollectionView() {
    XCTAssertNotNil(sut.collectionView)
  }
  
  func test_HasAddBtn() {
    XCTAssertNotNil(sut.addBtn)
  }
  
  func test_CategoryManagerOfCategoryDataProvider_SameAsCategoryManager() {
    XCTAssertEqual(sut.categoryDataProvider.categoryManager, sut.categoryManager)
  }
  
  func test_Title() {
    XCTAssertEqual(sut.title, "단어장")
  }
  
  func test_setupCard_SetThreeCategory() {
    XCTAssertEqual(3, sut.categoryManager.categories.count)
  }
  
  func test_collectionViewDataSource_IsCategoryDataProvider() {
    XCTAssertTrue(sut.collectionView.dataSource is CategoryDataProvider)
  }
  
  func test_collectionViewDelegate_IsCategoryDataProvider() {
    XCTAssertTrue(sut.collectionView.delegate is CategoryDataProvider)
  }
  
  func test_DataSourceAndDelegate_AreSame() {
    XCTAssertEqual(sut.collectionView.dataSource as? CategoryDataProvider, sut.collectionView.delegate as? CategoryDataProvider)
  }
  
  func test_addBtnTapped_presentUIAlertController() {
    XCTAssertNil(sut.presentedViewController)
    
    UIApplication.shared.keyWindow?.rootViewController = sut
    sut.addBtnTapped(sut.addBtn)
    XCTAssertTrue(sut.presentedViewController is UIAlertController)
  }
}
