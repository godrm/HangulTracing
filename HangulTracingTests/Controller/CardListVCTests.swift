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
    _ = sut.view
  }
  
  override func tearDown() {
    sut.dataProvider.cardManager?.removeAll()
    super.tearDown()
  }
  
  //tableView
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
  func test_Controller_HasBarBtnWithSelfAsTarget() {
    let target = sut.navigationItem.rightBarButtonItem?.target
    XCTAssertEqual(target as? CardListVC, sut)
  }
  
  func test_WhenAddBtnTapped_PresentInputVC() {
    XCTAssertNil(sut.presentedViewController)
    
    //버튼 띄우기
    UIApplication.shared.keyWindow?.rootViewController = sut
    
    guard let addBtn = sut.navigationItem.rightBarButtonItem else { XCTFail(); return }
    guard let action = addBtn.action else { XCTFail(); return }
    
    //클릭
    sut.performSelector(onMainThread: action, with: addBtn, waitUntilDone: true)
    XCTAssertTrue(sut.presentedViewController is InputVC)
  }
  
  func test_WhenAddedCard_CollectionViewReloaded() {
    let mockCollectionView = MockCollectionView(frame: CGRect(), collectionViewLayout: UICollectionViewFlowLayout())
    sut.collectionView = mockCollectionView
    sut.dataProvider.cardManager?.addCard(newCard: WordCard(word: "test", imageData: Data()))

    //viewwillappear
    sut.beginAppearanceTransition(true, animated: true)
    sut.endAppearanceTransition()
    sut.collectionView.layoutIfNeeded()
    
    XCTAssertTrue(mockCollectionView.reloadIsCalled)
  }
  
  //cardManager
  func test_ViewDidLoad_SetsCardManagerToDataProvider() {
    XCTAssertTrue(sut.cardManager === sut.dataProvider.cardManager)
  }
  
  
}

extension CardListVCTests {
  
  //reload 확인
  class MockCollectionView: UICollectionView {
    var reloadIsCalled = false
    
    override func reloadData() {
      reloadIsCalled = true
      super.reloadData()
    }
  }
  
  //pushVC 확인
  class MockNavigationController: UINavigationController {
    var pushedVC: UIViewController?
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
      pushedVC = viewController
      super.pushViewController(viewController, animated: animated)
    }
  }
}

