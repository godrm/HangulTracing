//
//  CardListVCTests.swift
//  HangulTracingTests
//
//  Created by junwoo on 2017. 11. 9..
//  Copyright © 2017년 samchon. All rights reserved.
//

import XCTest
@testable import HangulTracing

class CardListVCTests: XCTestCase {
    
  var sut: CardListVC!
  
  override func setUp() {
    super.setUp()
    sut = CardListVC()
    sut.category = Category(category: "동물")
    sut.cardManager = CardManager(categoryTitle: "동물")
    _ = sut.view
    
  }
  
  override func tearDown() {
    sut.dataProvider.cardManager?.makeRealmEmpty()
    super.tearDown()
  }
  
  func test_HasTitle() {
    XCTAssertEqual(sut.title, "동물")
  }
  
  func test_HasCollectionView() {
    XCTAssertNotNil(sut.collectionView)
  }
  
  func test_HasAddBtn() {
    XCTAssertNotNil(sut.addBtn)
  }
  
  //collectionView
  func test_CollectionView_IsNotNil_AfterViewDidLoad() {
    XCTAssertNotNil(sut.collectionView)
  }
  
  //datasource
  func test_WhenViewDidLoad_SetsCollectionViewDataSource() {
    XCTAssertTrue(sut.collectionView.dataSource is DataProvider)
  }
  
  //delegate
  func test_WhenViewDidLoad_SetsCollectionViewDelegate() {
    XCTAssertTrue(sut.collectionView.delegate is DataProvider)
  }
  
  func test_WhenViewDidLoad_DataSourceAndDelegateAreSame() {
    XCTAssertEqual(sut.collectionView.dataSource as? DataProvider, sut.collectionView.delegate as? DataProvider)
  }
  
  //UIBarButton
  func test_Controller_HasRightBarBtnWithSelfAsTarget() {
    let target = sut.navigationItem.rightBarButtonItem?.target
    XCTAssertEqual(target as? CardListVC, sut)
  }
  
  //addBtn
  func test_WhenAddBtnTapped_PresentInputVC() {
    XCTAssertNil(sut.presentedViewController)

    //버튼 띄우기
    UIApplication.shared.keyWindow?.rootViewController = sut

    sut.addBtnTapped(sut.addBtn)
    XCTAssertTrue(sut.presentedViewController is InputVC)
  }
  
  //cardManager
  func test_ViewDidLoad_SetsCardManagerToDataProvider() {
    XCTAssertTrue(sut.cardManager === sut.dataProvider.cardManager)
  }
  
}
