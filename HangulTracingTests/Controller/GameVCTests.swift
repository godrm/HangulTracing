//
//  GameVCTests.swift
//  HangulTracingTests
//
//  Created by junwoo on 2017. 11. 14..
//  Copyright © 2017년 samchon. All rights reserved.
//

import XCTest
@testable import HangulTracing

class GameVCTests: XCTestCase {
  var sut: GameVC!
  
  override func setUp() {
    super.setUp()
    sut = GameVC()
    sut.cardManager = CardManager()
    _ = sut.view
  }
  
  override func tearDown() {
    sut.cardManager?.removeAll()
    super.tearDown()
  }
  
  func test_HasTimerLabel() {
    XCTAssertNotNil(sut.timerLabel)
  }
  func test_HasSeconds() {
    XCTAssertNotNil(sut.seconds)
  }
  func test_HasSpeechSynthesizer() {
    XCTAssertNotNil(sut.speechSynthesizer)
  }
  func test_HasBlurEffecView() {
    XCTAssertNotNil(sut.blurEffectView)
  }
  func test_HasMotionManager() {
    XCTAssertNotNil(sut.motionManager)
  }
  func test_HasCardManager() {
    XCTAssertNotNil(sut.cardManager)
  }
  func test_HasScrollView() {
    XCTAssertNotNil(sut.scrollView)
  }
  func test_HasStartView() {
    XCTAssertNotNil(sut.startView)
  }
  func test_HasGreatCount() {
    XCTAssertNotNil(sut.greatCount)
  }
  
  func test_viewWillAppear_callInputCardToScrollView() {
    let mockGameVC = MockGameVC()
    mockGameVC.beginAppearanceTransition(true, animated: true)
    mockGameVC.endAppearanceTransition()
    XCTAssertTrue(mockGameVC.inputCardToScrollViewIsCalled)
  }
  func test_inputCardToScrollView_increaseScrollviewSubViewcount() {
    sut.cardManager?.addCard(newCard: WordCard(word: "게임", imageData: Data()))
    sut.beginAppearanceTransition(true, animated: true)
    sut.endAppearanceTransition()
    XCTAssertNotEqual(sut.scrollView.subviews.count, 0)
  }
}

extension GameVCTests {
  
  class MockGameVC: GameVC {
    var inputCardToScrollViewIsCalled = false
    
    override func inputCardToScrollView() {
      inputCardToScrollViewIsCalled = true
      super.inputCardToScrollView()
    }
  }
}
