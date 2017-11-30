//
//  TracingVCTests.swift
//  HangulTracingTests
//
//  Created by junwoo on 2017. 11. 7..
//  Copyright © 2017년 samchon. All rights reserved.
//

import XCTest
@testable import HangulTracing

class TracingVCTests: XCTestCase {
  
  var sut: TracingVC!
  
  override func setUp() {
    super.setUp()
    sut = TracingVC()
    let cardManager = CardManager.instance
    cardManager.changeCategory(category: "동물")
    let catCard = WordCard(word: "고양이", imageData: WordCards().catImgData!, category: "동물")
    cardManager.addCard(newCard: catCard)
    sut.setCardInfo(index: 0)
    
    _ = sut.view
  }
  
  override func tearDown() {
    sut.cardInfo?.0.makeRealmEmpty()
    super.tearDown()
  }
  
  func test_HasScrollView() {
    XCTAssertNotNil(sut.scrollView)
  }
  
  func test_getCharactersView_MakeView_SameAsCharatersCount() {
    //고양이
    sut.getCharactersView()
    let subViewCounts = sut.scrollView.subviews.count
    XCTAssertEqual(3, subViewCounts)
  }
  
  func test_WhenViewWillAppear_Call_getCharactersView() {
    let mockTracingVC = MockTracingVC()
    let category = Category(category: "동물")
    let cardManager = CardManager.instance
    cardManager.changeCategory(category: category.title)
    mockTracingVC.setCardInfo(index: 0)
    UIApplication.shared.keyWindow?.rootViewController = mockTracingVC
    mockTracingVC.beginAppearanceTransition(true, animated: true)
    mockTracingVC.endAppearanceTransition()
    
    XCTAssertTrue(mockTracingVC.getCharactersViewIsCalled)
  }
  
  func test_WhenViewWillDisappear_Call_SetNavigationBarHidden() {
    let mockNav = MockNavigationController(rootViewController: sut)
    sut.dismiss(animated: true) {
      XCTAssertTrue(mockNav.setNavigatinoBarHiddenIsCalled)
    }
    
  }
  
}

extension TracingVCTests {
  
  class MockTracingVC: TracingVC {
    var getCharactersViewIsCalled = false
    
    override func getCharactersView() {
      getCharactersViewIsCalled = true
      super.getCharactersView()
    }
    
  }
  
  class MockNavigationController: UINavigationController {
    var popIsCalled = false
    var setNavigatinoBarHiddenIsCalled = false
    
    override func popViewController(animated: Bool) -> UIViewController? {
      popIsCalled = true
      return super.popViewController(animated: animated)
    }
    
    override func setNavigationBarHidden(_ hidden: Bool, animated: Bool) {
      setNavigatinoBarHiddenIsCalled = true
      super.setNavigationBarHidden(hidden, animated: animated)
    }
  }
}
