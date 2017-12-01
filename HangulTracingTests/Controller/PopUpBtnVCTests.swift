//
//  PopUpBtnVCTests.swift
//  HangulTracingTests
//
//  Created by junwoo on 2017. 12. 1..
//  Copyright © 2017년 samchon. All rights reserved.
//

import XCTest
@testable import HangulTracing

class PopUpBtnVCTests: XCTestCase {
  var sut: PopUpBtnVC!
  
  override func setUp() {
    super.setUp()
    sut = PopUpBtnVC()
    _ = sut.view
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func test_HasProperty() {
    XCTAssertNotNil(sut.addCardBtn)
    XCTAssertNotNil(sut.addCardLabel)
    XCTAssertNotNil(sut.cancleBtn)
    XCTAssertNotNil(sut.hideBtn)
    XCTAssertNotNil(sut.gameBtn)
    XCTAssertNotNil(sut.saveBtn)
    XCTAssertNotNil(sut.gameLabel)
    XCTAssertNotNil(sut.presenting)
    XCTAssertNotNil(sut.popUpView)
    XCTAssertNotNil(sut.deleteCardLabel)
    XCTAssertNotNil(sut.categoryTxtField)
    XCTAssertNotNil(sut.deleteCardBtn)
  }
  
  func test_WhenViewWillAppear_CallAnimateBtn() {
    let mockPopUpBtnVC = MockPopUpBtnVC()
    UIApplication.shared.keyWindow?.rootViewController = mockPopUpBtnVC
    _ = mockPopUpBtnVC.view
    sut.beginAppearanceTransition(true, animated: true)
    sut.endAppearanceTransition()
    XCTAssertTrue(mockPopUpBtnVC.animateBtnIsCalled)
  }
  
  func test_WhenDisimissPopUp_CallAnimateBtn() {
    let mockPopUpBtnVC = MockPopUpBtnVC()
    UIApplication.shared.keyWindow?.rootViewController = mockPopUpBtnVC
    _ = mockPopUpBtnVC.view
    sut.dismissPopUp()
    XCTAssertTrue(mockPopUpBtnVC.animateBtnIsCalled)
  }
  
  func test_SaveBtnTapped_increaseCategoryCount() {
    UIApplication.shared.keyWindow?.rootViewController = sut
    let categoryVC = CategoryVC()
    _ = categoryVC.view
    XCTAssertEqual(categoryVC.categoryManager.categories.count, 3)
    sut.setParentVC(vc: categoryVC)
    sut.categoryTxtField.text = "test"
    sut.saveBtnTapped(sut.saveBtn)
    XCTAssertEqual(categoryVC.categoryManager.categories.count, 4)
  }
  
  func test_WhenParentVCisCardListVC_addCardBtnTapped_presentInputVC() {
    let cardListVC = CardListVC()
    sut.setParentVC(vc: cardListVC)
    UIApplication.shared.keyWindow?.rootViewController = cardListVC
    cardListVC.present(sut, animated: true) {
      self.sut.addCardBtnTapped(self.sut.addCardBtn)
      XCTAssertTrue(cardListVC.presentedViewController is InputVC)
    }
    
  }
  
  func test_WhenParentVCisCategoryVC_addCardBtnTapped_popupViewHidden() {
    let categoryVC = CategoryVC()
    sut.setParentVC(vc: categoryVC)
    UIApplication.shared.keyWindow?.rootViewController = categoryVC
    categoryVC.present(sut, animated: true) {
      self.sut.addCardBtnTapped(self.sut.addCardBtn)
      XCTAssertTrue(self.sut.popUpView.isHidden)
    }
  }
  
}

extension PopUpBtnVCTests {
  class MockPopUpBtnVC: PopUpBtnVC {
    var animateBtnIsCalled = false
    override func animateBtn(completion: @escaping CompletionHandler) {
      animateBtnIsCalled = true
      super.animateBtn(completion: completion)
    }
  }
}
