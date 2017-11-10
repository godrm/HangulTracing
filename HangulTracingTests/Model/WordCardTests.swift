//
//  WordCardTests.swift
//  HangulTracingTests
//
//  Created by junwoo on 2017. 11. 3..
//  Copyright © 2017년 samchon. All rights reserved.
//

import XCTest
@testable import HangulTracing

class WordCardTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  //word
  func test_Init_WhenGivenWord_SetsWord() {
    let wordCard = WordCard(word: "다람쥐", imageData: Data())
    XCTAssertEqual(wordCard.word, "다람쥐")
  }
  
  //imgData
  func test_Init_WhenGivenData_SetsImgData() {
    let testData = Data()
    let wordCard = WordCard(word: "test", imageData: testData)
    XCTAssertEqual(wordCard.imgData, testData)
  }
}
