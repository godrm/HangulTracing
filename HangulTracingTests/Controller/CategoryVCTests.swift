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
    
    //card 가 셋업되어 있다
  }
  
  override func tearDown() {
    sut.categoryManager.makeRealmEmpty()
    super.tearDown()
  }
  
  func test_HasProperty() {
    XCTAssertNotNil(sut.categoryDataProvider)
    XCTAssertNotNil(sut.categoryManager)
    XCTAssertNotNil(sut.categoryDataProvider)
    XCTAssertNotNil(sut.collectionView)
    XCTAssertNotNil(sut.showBtn)
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
  
  func test_showBtnTapped_ShowPopUpView() {
    XCTAssertNil(sut.presentedViewController)
    
    UIApplication.shared.keyWindow?.rootViewController = sut
    sut.showBtnTapped(sut.showBtn)
    XCTAssertTrue(sut.presentedViewController is PopUpBtnVC)
  }
  
  func test_deleteBtnTapped_presentUIAlertController() {
    XCTAssertNil(sut.presentedViewController)
    
    UIApplication.shared.keyWindow?.rootViewController = sut
    sut.collectionView.reloadData()
    sut.collectionView.layoutIfNeeded()
    guard let categoryCell = sut.collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? CategoryCell else { fatalError() }
    sut.deleteBtnTapped(sender: categoryCell.deleteBtn)
    XCTAssertTrue(sut.presentedViewController is UIAlertController)
  }
}
