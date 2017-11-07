//
//  CardListDataProviderTests.swift
//  HangulTracingTests
//
//  Created by junwoo on 2017. 11. 4..
//  Copyright © 2017년 samchon. All rights reserved.
//

import XCTest
@testable import HangulTracing

//provider, tableview
class CardListDataProviderTests: XCTestCase {
  
  var provider: CardListDataProvider!
  var controller: WordsListVC!
  var tableView: UITableView!
  
  override func setUp() {
    super.setUp()
    controller = WordsListVC()
    provider = CardListDataProvider()
    provider.cardManager = CardManager()
    
    _ = controller.view
    
    tableView = controller.tableView
    tableView.dataSource = provider
    tableView.delegate = provider
  }
  
  override func tearDown() {
    provider.cardManager?.removeAll()
    super.tearDown()
  }
  
  //numberOfSections
  func test_NumberOfSections_IsOne() {
    XCTAssertEqual(tableView.numberOfSections, 1)
  }
  
  //tableview test할때 reloadData 해줘야 함
  //numberofRows
  func test_NumberOfRowsInFirstSection_IsToDoCount() {
    let first = WordCard(word: "first")
    let second = WordCard(word: "second")
    provider.cardManager?.addCard(newCard: first)
    XCTAssertEqual(tableView.numberOfRows(inSection: 0), 1)
    
    provider.cardManager?.addCard(newCard: second)
    tableView.reloadData()
    XCTAssertEqual(tableView.numberOfRows(inSection: 0), 2)
  }
  
  //cellForRowAt
  func test_CellForRowAt_ReturnCardCell() {
    provider.cardManager?.addCard(newCard: WordCard(word: "test"))
    
    tableView.reloadData()
    let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
    XCTAssertTrue(cell is CardCell)
    XCTAssertNotNil(cell)
  }
  
  //Dequeue (이때 cell을 register 해줘야 dequeue 가 된다)
  func test_WhenCellForRowAt_DequeueCalled() {
    let mockTableView = MockTableView.mockTableView(provider)
    provider.cardManager?.addCard(newCard: WordCard(word: "fff"))
    
    mockTableView.reloadData()
    _ = mockTableView.cellForRow(at: IndexPath(row: 0, section: 0))
    XCTAssertTrue(mockTableView.dequeueIsCalled)
  }
  
  //deleteBtn
  func test_DeleteBtnInFirstSection_ShowsTitle() {
    let title = tableView.delegate?.tableView?(tableView, titleForDeleteConfirmationButtonForRowAt: IndexPath(row: 0, section: 0))
    XCTAssertEqual(title, "COMPLETE")
  }
  
  func test_DeleteBtnInFirstSection_Simulation() {
    provider.cardManager?.addCard(newCard: WordCard(word: "new"))
    XCTAssertEqual(provider.cardManager?.toDoCount, 1)
    //버튼 클릭
    tableView.dataSource?.tableView?(tableView, commit: .delete, forRowAt: IndexPath(row: 0, section: 0))
    XCTAssertEqual(provider.cardManager?.toDoCount, 0)
  }
  
  //notification sender
  func test_SelectingACell_SendsNotification() {
    let card = WordCard(word: "noti")
    provider.cardManager?.addCard(newCard: card)
    
    //index가 0일 것이다
    expectation(forNotification: Constants().NOTI_CARD_SELECTED, object: nil) { (notification) -> Bool in
      guard let index = notification.userInfo?["index"] as? Int else {
        return false
      }
      return index == 0
    }
    
    //셀 클릭
    tableView.delegate?.tableView!(tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
    
    waitForExpectations(timeout: 3, handler: nil)
  }
}


//dequeue 호출 확인하기 위해
extension CardListDataProviderTests {
  
  class MockTableView: UITableView {
    
    var dequeueIsCalled: Bool = false
    
    override func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell {
      dequeueIsCalled = true
      
      return super.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
    }
    
    class func mockTableView(_ dataSource: UITableViewDataSource) -> MockTableView {
      let mockTableView = MockTableView(frame: CGRect(x: 0, y: 0, width: 300, height: 600))
      mockTableView.dataSource = dataSource
      mockTableView.register(MockCell.self, forCellReuseIdentifier: "CardCell")
      
      return mockTableView
    }
  }
  
  class MockCell: CardCell {
    
    
  }
  
}
