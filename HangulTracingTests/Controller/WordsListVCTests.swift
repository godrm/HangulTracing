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
  
  //datasource
  func test_WhenViewDidLoad_SetsTableViewDataSource() {
    XCTAssertTrue(sut.tableView.dataSource is CardListDataProvider)
  }
  
  //delegate
  func test_WhenViewDidLoad_SetsTableViewDelegate() {
    XCTAssertTrue(sut.tableView.delegate is CardListDataProvider)
  }
  
  func test_WhenViewDidLoad_DataSourceAndDelegateAreSame() {
    XCTAssertEqual(sut.tableView.dataSource as? CardListDataProvider, sut.tableView.delegate as? CardListDataProvider)
  }
  
  //addBtn
  func test_Controller_HasBarBtnWithSelfAsTarget() {
    let target = sut.navigationItem.rightBarButtonItem?.target
    XCTAssertEqual(target as? WordsListVC, sut)
  }
  
  func test_WhenAddBtnTapped_PresentInputVC() {
    XCTAssertNil(sut.presentedViewController)
    
    //버튼 띄우기
    UIApplication.shared.keyWindow?.rootViewController = sut
    
    guard let addBtn = sut.navigationItem.rightBarButtonItem else { XCTFail(); return }
    guard let action = addBtn.action else { XCTFail(); return }
    
    //클릭
    sut.performSelector(onMainThread: action, with: addBtn, waitUntilDone: true)
    XCTAssertTrue(sut.presentedViewController is InputVC)
  }
}
