//
//  InputVCTests.swift
//  HangulTracingTests
//
//  Created by junwoo on 2017. 11. 10..
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
    sut.cardManager = CardManager()
  }
  
  override func tearDown() {
    sut.cardManager?.removeAll()
    super.tearDown()
  }
  
  func test_Has_wordTextField() {
    XCTAssertNotNil(sut.wordTextField)
  }
  
  func test_Has_imageView() {
    XCTAssertNotNil(sut.imageView)
  }
  
  func test_Has_cameraBtn() {
    XCTAssertNotNil(sut.cameraBtn)
  }
  
  func test_Has_addBtn() {
    XCTAssertNotNil(sut.addBtn)
  }
  
  func test_Has_cancelBtn() {
    XCTAssertNotNil(sut.cancelBtn)
  }
  
  func test_AddBtn_HasAction() {
    let addBtn: UIButton = sut.addBtn

    guard let actions = addBtn.actions(forTarget: sut, forControlEvent: .touchUpInside) else {
      XCTFail(); return
    }

    XCTAssertTrue(actions.contains("addBtnTapped:"))
  }
  
  func test_WhenGivenTextAndIMG_AddBtn_Call_Dismiss() {
    let mockInputVC = MockInputVC()
    mockInputVC.wordTextField.text = "가나초콜릿"
    mockInputVC.capturedPhotoData = Data()
    let addBtn: UIButton = mockInputVC.addBtn
    mockInputVC.addBtnTapped(addBtn)
    XCTAssertTrue(mockInputVC.dismissIsCalled)
  }
  
  func test_WhenNotGivenTextAndIMG_AddBtn_NotCall_Dismiss() {
    let mockInputVC = MockInputVC()
    mockInputVC.wordTextField.text = ""
    mockInputVC.capturedPhotoData = Data()
    let addBtn: UIButton = mockInputVC.addBtn
    mockInputVC.addBtnTapped(addBtn)
    XCTAssertFalse(mockInputVC.dismissIsCalled)
  }
  
  func test_cameraBtn_HasAction() {
    let cameraBtn = sut.cameraBtn
    guard let actions = cameraBtn.actions(forTarget: sut, forControlEvent: .touchUpInside) else { XCTFail(); return }
    XCTAssertTrue(actions.contains("cameraBtnTapped:"))
  }
  
  func test_cancelBtn_HasAction() {
    let cancelBtn = sut.cancelBtn
    guard let actions = cancelBtn.actions(forTarget: sut, forControlEvent: .touchUpInside) else { XCTFail(); return }
    XCTAssertTrue(actions.contains("cancelBtnTapped:"))
  }
  
  func test_cancelBtn_callDismiss() {
    let mockInputVC = MockInputVC()
    let cancelBtn: UIButton = mockInputVC.cancelBtn
    mockInputVC.cancelBtnTapped(cancelBtn)
    XCTAssertTrue(mockInputVC.dismissIsCalled)
  }
}

extension InputVCTests {
  class MockInputVC: InputVC {
    var dismissIsCalled = false
    var completionHandler: (() -> Void)?
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
      dismissIsCalled = true
      completionHandler?()
    }
  }
}
