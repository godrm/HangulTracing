//
//  InputVCTests.swift
//  HangulTracingTests
//
//  Created by junwoo on 2017. 11. 4..
//  Copyright © 2017년 samchon. All rights reserved.
//

import XCTest
@testable import HangulTracing

class InputVCTests: XCTestCase {
  
  var sut: InputVC!
  
  override func setUp() {
    super.setUp()
    sut = InputVC()
    _ = sut.view
  }
  
  override func tearDown() {
    sut.cardManager?.removeAll()
    super.tearDown()
  }
  
  func test_HasTextField() {
    XCTAssertNotNil(sut.wordTextField)
  }
  
  func test_HasSaveBtn() {
    XCTAssertNotNil(sut.saveBtn)
  }
  
  func test_SaveBtnAction_HasSaveBtnTapped() {
    guard let actions = sut.saveBtn.actions(forTarget: sut, forControlEvent: .touchUpInside) else { return }
    XCTAssertTrue(actions.contains("saveBtnTapped:"))
  }
  
  func test_SaveBtnTapped_DismissCalled() {
    let mockInputVC = MockInputVC()
    mockInputVC.wordTextField.text = "왕"
    mockInputVC.saveBtnTapped(mockInputVC.saveBtn)
    XCTAssertTrue(mockInputVC.dismissIsCalled)
  }
}

extension InputVCTests {
  
  class MockInputVC: InputVC {
    var dismissIsCalled: Bool = false
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
      dismissIsCalled = true
    }
  }
}
