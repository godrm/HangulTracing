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
    let cardListVC = CardListVC()
    cardListVC.cardManager.changeCategory(category: "동물")
    sut.setParentVC(vc: cardListVC)
    
    _ = sut.view
  }
  
  override func tearDown() {
    sut.cardManager.makeRealmEmpty()
    super.tearDown()
  }
  
  func test_HasViewFrame() {
    XCTAssertNotNil(sut.viewFrame)
  }
  
  func test_HasImgView() {
    XCTAssertNotNil(sut.imgView)
  }
  
  func test_imgViewContentmode_aspectFill() {
    XCTAssertEqual(sut.imgView.contentMode, .scaleAspectFill)
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
    let cardListVC = CardListVC()
    cardListVC.cardManager.changeCategory(category: "동물")
    let nav = UINavigationController(rootViewController: cardListVC)
    UIApplication.shared.keyWindow?.rootViewController = nav
    let mockCellVC = MockCellVC(viewFrame: CGRect(x: 0, y: 0, width: 100, height: 100))
    mockCellVC.setParentVC(vc: cardListVC)
    mockCellVC.wordLBLTapped()
    XCTAssertTrue(mockCellVC.flipIsCalled)
  }
  
  func test_WhenTracingBtnTapped_dismissCellVC() {
    let cardListVC = CardListVC()
    cardListVC.cardManager.changeCategory(category: "동물")
    cardListVC.cardManager.addCard(newCard: WordCard(word: "고양이", imageData: WordCards().catImgData!, category: "동물"))
    
    let mockCellVC = MockCellVC(viewFrame: CGRect(x: 0, y: 0, width: 100, height: 100))
    mockCellVC.setParentVC(vc: cardListVC)
    mockCellVC.configView(card: cardListVC.cardManager.cardAt(index: 0))
    mockCellVC.transitioningDelegate = cardListVC
    _ = cardListVC.view
    cardListVC.present(mockCellVC, animated: true, completion: nil)
    _ = mockCellVC.view
    mockCellVC.tracingBtnTapped(mockCellVC.tracingBtn)

    XCTAssertTrue(mockCellVC.dismissIsCalled)
  }
}


extension CellVCTests {
  class MockCellVC: CellVC {
    var flipIsCalled = false
    override func flip(completion: @escaping (Bool) -> ()) {
      flipIsCalled = true
      super.flip(completion: completion)
    }
    
    var dismissIsCalled = false
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
      dismissIsCalled = true
      super.dismiss(animated: flag, completion: completion)
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
