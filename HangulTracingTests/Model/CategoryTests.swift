//
//  CategoryTests.swift
//  HangulTracingTests
//
//  Created by junwoo on 2017. 11. 23..
//  Copyright © 2017년 samchon. All rights reserved.
//

import XCTest
@testable import HangulTracing

class CategoryTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  //title
  func test_Init_WhenGivenTitle_SetsTitle() {
    let category = Category(category: "title")
    XCTAssertEqual(category.title, "title")
  }
  
}
