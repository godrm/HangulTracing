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
  
}
