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
    let category = Category(category: "동물")
    let wordCard = WordCard(word: "다람쥐", imageData: Data(), category: category.title)
    XCTAssertEqual(wordCard.word, "다람쥐")
  }
  
  
  func test_Init_WhenGivenCategory_SetsCategory() {
    let category = Category(category: "동물")
    let wordCard = WordCard(word: "다람쥐", imageData: Data(), category: category.title)
    XCTAssertEqual(wordCard.category, "동물")
  }
  
  //imgData
  func test_Init_WhenGivenData_SetsImgData() {
    let testData = Data()
    let category = Category(category: "동물")
    let wordCard = WordCard(word: "test", imageData: testData, category: category.title)
    XCTAssertEqual(wordCard.imgData, testData)
  }
}
