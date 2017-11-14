//
//  GameViewTests.swift
//  HangulTracingTests
//
//  Created by junwoo on 2017. 11. 14..
//  Copyright © 2017년 samchon. All rights reserved.
//

import XCTest
@testable import HangulTracing

class GameViewTests: XCTestCase {
  
  var gameView: GameView!
  
  override func setUp() {
    super.setUp()
    gameView = GameView(frame: CGRect(x: 0, y: 0, width: 300, height: 600), word: "게임")
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func test_HasWords() {
    XCTAssertNotNil(gameView.words)
  }
  func test_HasWordLabel() {
    XCTAssertNotNil(gameView.wordLabel)
  }
  func test_Has_exitBtn() {
    XCTAssertNotNil(gameView.exitBtn)
  }
  func test_setWords_isSetWordLblText() {
    gameView.setWords(words: "새단어")
    XCTAssertEqual("새단어", gameView.wordLabel.text)
  }
  
}
