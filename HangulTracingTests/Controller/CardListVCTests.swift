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
    sut.cardManager.changeCategory(category: "동물")
    sut.cardManager.addCard(newCard: WordCard(word: "고양이", imageData: WordCards().catImgData!, category: "동물"))
    
    _ = sut.view
    sut.collectionView.reloadData()
    sut.collectionView.layoutIfNeeded()
  }
  
  override func tearDown() {
    sut.dataProvider.cardManager?.makeRealmEmpty()
    super.tearDown()
  }
  
  func test_HasProperty() {
    XCTAssertEqual(sut.title, "동물")
    XCTAssertNotNil(sut.collectionView)
    XCTAssertNotNil(sut.showBtn)
    XCTAssertNotNil(sut.dataProvider)
    XCTAssertNotNil(sut.cardManager)
    XCTAssertNotNil(sut.cellMode)
    XCTAssertNotNil(sut.initialTouchPoint)
    XCTAssertNotNil(sut.showBtn)
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
  
  //ShowBtn
  func test_WhenShowBtnTapped_PresentPopupVC() {
    XCTAssertNil(sut.presentedViewController)

    //버튼 띄우기
    UIApplication.shared.keyWindow?.rootViewController = sut

    sut.showBtnTapped(sut.showBtn)
    XCTAssertTrue(sut.presentedViewController is PopUpBtnVC)
  }
  
  //cardManager
  func test_ViewDidLoad_SetsCardManagerToDataProvider() {
    XCTAssertTrue(sut.cardManager === sut.dataProvider.cardManager)
  }
  
  func test_deleteBtnTapped_presentUIAlertController() {
    UIApplication.shared.keyWindow?.rootViewController = sut
    XCTAssertNil(sut.presentedViewController)
    sut.cardManager.addCard(newCard: WordCard(word: "고양이", imageData: WordCards().catImgData!, category: "동물"))
    sut.collectionView.reloadData()
    sut.collectionView.layoutIfNeeded()
    guard let wordCardCell = sut.collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? WordCardCell else { fatalError() }
    sut.deleteBtnTapped(sender: wordCardCell.deleteBtn)
    XCTAssertTrue(sut.presentedViewController is UIAlertController)
  }
  
  func test_presentCellVC() {
    UIApplication.shared.keyWindow?.rootViewController = sut
    sut.presentCellVC(indexPath: IndexPath(item: 0, section: 0))
    XCTAssertTrue(sut.presentedViewController is CellVC)
  }
  
  func test_pushTracingVC() {
    let mockNav = MockNav(rootViewController: sut)
    
    UIApplication.shared.keyWindow?.rootViewController = mockNav
    sut.presentCellVC(indexPath: IndexPath(item: 0, section: 0))
    sut.presentedViewController?.dismiss(animated: true, completion: {
      self.sut.pushTracingVC()
      XCTAssertTrue(mockNav.pushedVC is TracingVC)
    })
    
  }
  
}

extension CardListVCTests {
  class MockNav: UINavigationController {
    var pushedVC: UIViewController?
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
      pushedVC = viewController
      super.pushViewController(viewController, animated: animated)
    }
  }
}
