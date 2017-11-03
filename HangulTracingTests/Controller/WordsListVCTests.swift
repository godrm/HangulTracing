//
//  WordsListVCTests.swift
//  HangulTracingTests
//
//  Created by junwoo on 2017. 11. 3..
//  Copyright © 2017년 samchon. All rights reserved.
//

import XCTest
@testable import HangulTracing

class WordsListVCTests: XCTestCase {
  
  var sut: WordsListVC!
  
  override func setUp() {
    super.setUp()
    sut = WordsListVC()
    _ = sut.view
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  //tableView
  func test_TableView_IsNotNil_AfterViewDidLoad() {
    XCTAssertNotNil(sut.tableView)
  }
  
}
