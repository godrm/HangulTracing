//
//  LetterViewTests.swift
//  HangulTracingTests
//
//  Created by junwoo on 2017. 11. 7..
//  Copyright © 2017년 samchon. All rights reserved.
//

import XCTest
@testable import HangulTracing

class LetterViewTests: XCTestCase {
  
  var letterView: LetterView!
  
  override func setUp() {
    super.setUp()
    let tracingVC = TracingVC()
    _ = tracingVC.view
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
}
