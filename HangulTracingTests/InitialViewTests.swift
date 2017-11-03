//
//  InitialViewTests.swift
//  HangulTracingTests
//
//  Created by junwoo on 2017. 11. 3..
//  Copyright © 2017년 samchon. All rights reserved.
//

import XCTest
@testable import HangulTracing

class InitialViewTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func test_InitialViewControllerIsWordsListVC() {
    
    let navigationController = UIApplication.shared.keyWindow?.rootViewController as! UINavigationController
    let rootViewController = navigationController.viewControllers[0]
    XCTAssertTrue(rootViewController is WordsListVC)
    
  }
  
}
