//
//  CellVCTests.swift
//  HangulTracingTests
//
//  Created by junwoo on 2017. 11. 22..
//  Copyright © 2017년 samchon. All rights reserved.
//

import XCTest
@testable import HangulTracing

class CellVCTests: XCTestCase {
  
  var sut: CellVC!
  
  override func setUp() {
    super.setUp()
    sut = CellVC(viewFrame: CGRect(x: 0, y: 0, width: 100, height: 100))
    sut.index = 0
    sut.cardManager = CardManager(categoryTitle: "동물")
    _ = sut.view
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func test_HasViewFrame() {
    XCTAssertNotNil(sut.viewFrame)
  }
  
  func test_HasImgView() {
    XCTAssertNotNil(sut.imgView)
  }
  
  func test_HasAudioPlayer() {
    XCTAssertNotNil(sut.audioPlayer)
  }
  
  func test_HasBackView() {
    XCTAssertNotNil(sut.backView)
  }
  
  func test_HasWordLabel() {
    XCTAssertNotNil(sut.wordLabel)
  }
  
  func test_HasTracingBtn() {
    XCTAssertNotNil(sut.tracingBtn)
  }
  
  func test_configViewSetTextAndImg() {
    let card = WordCard(word: "사슴", imageData: Data(), category: "동물")
    sut.configView(card: card)
    XCTAssertEqual(sut.wordLabel.text, "사슴")
    XCTAssertEqual(sut.imgView.image, UIImage(data: card.imgData))
  }
  
  func test_WhenWordLabelTapped_flipCalled() {
    let mockCellVC = MockCellVC(viewFrame: CGRect(x: 0, y: 0, width: 100, height: 100))
    mockCellVC.wordLBLTapped()
    XCTAssertTrue(mockCellVC.flipIsCalled)
  }
  
//  func test_WhenTracingBtnTapped_PushTracingVC() {
//    let cardListVC = CardListVC()
//    let mockNav = MockNavigationController(rootViewController: cardListVC)
//    UIApplication.shared.keyWindow?.rootViewController = mockNav
//    cardListVC.category = Category(category: "동물")
//    cardListVC.cardManager = CardManager(categoryTitle: "동물")
//    cardListVC.cardManager?.addCard(newCard: WordCard(word: "사슴", imageData: Data(), category: "동물"))
//     _ = cardListVC.view
//    cardListVC.collectionView.reloadData()
//    cardListVC.collectionView.layoutIfNeeded()
//
//    cardListVC.collectionView.delegate?.collectionView!(cardListVC.collectionView, didSelectItemAt: IndexPath(item: 0, section: 0))
//    guard let cellVC = cardListVC.presentedViewController as? CellVC else { fatalError() }
//    _ = cellVC.view
//    cellVC.tracingBtnTapped(cellVC.tracingBtn)
//
//    XCTAssertTrue(mockNav.pushedVC is TracingVC)
//  }
}


extension CellVCTests {
  class MockCellVC: CellVC {
    var flipIsCalled = false
    override func flip(completion: @escaping (Bool) -> ()) {
      flipIsCalled = true
      super.flip(completion: completion)
    }
  }
  
  class MockNavigationController: UINavigationController {
    var pushedVC: UIViewController?
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
      pushedVC = viewController
      super.pushViewController(viewController, animated: animated)
    }
  }
}
