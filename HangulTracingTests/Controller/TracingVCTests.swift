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
    _ = sut.view
    
  }
  
  override func tearDown() {
    sut.cardInfo?.0.removeAll()
    super.tearDown()
  }
  
  func test_HasScrollView() {
    XCTAssertNotNil(sut.scrollView)
  }
  
//  func test_getCharactersView_MakeView_SameAsCharatersCount() {
//    let category = Category(category: "동물")
//    let cardManager = CardManager(categoryTitle: category.title)
//    cardManager.addCard(newCard: WordCard(word: "test", imageData: Data(), category: category.title))
//    sut.cardInfo = (cardManager, 0)
//    sut.getCharactersView()
//
//    let subViewCounts = sut.scrollView.subviews.count
//    XCTAssertEqual(4, subViewCounts)
//  }
  
  func test_WhenViewWillAppear_Call_getCharactersView() {
    let mockTracingVC = MockTracingVC()
    let category = Category(category: "동물")
    let cardManager = CardManager(categoryTitle: category.title)
    cardManager.addCard(newCard: WordCard(word: "test", imageData: Data(), category: category.title))
    mockTracingVC.cardInfo = (cardManager, 0)
    mockTracingVC.beginAppearanceTransition(true, animated: true)
    mockTracingVC.endAppearanceTransition()
    XCTAssertTrue(mockTracingVC.getCharactersViewIsCalled)
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
}
