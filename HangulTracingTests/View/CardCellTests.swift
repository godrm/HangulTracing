//
//  CardCellTests.swift
//  HangulTracingTests
//
//  Created by junwoo on 2017. 11. 3..
//  Copyright © 2017년 samchon. All rights reserved.
//

import XCTest
@testable import HangulTracing

//cell, tableView, datasource
class CardCellTests: XCTestCase {
  
  var cell: CardCell!
  var tableView: UITableView!
  let dataSource = FakeDataSource()
  
  override func setUp() {
    super.setUp()
    let wordsListVC = WordsListVC()
    
    //viewdidload
    _ = wordsListVC.view
    tableView = wordsListVC.tableView
    tableView.dataSource = dataSource
    
    //dequeue
    cell = tableView.dequeueReusableCell(withIdentifier: "CardCell", for: IndexPath(row: 0, section: 0)) as! CardCell
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  //wordLabel
  func test_HasWordLabel() {
    XCTAssertNotNil(cell.wordLabel)
  }
  
  //configCell
  func test_ConfigCell_SetsWordLabelText() {
    cell.configCell(card: WordCard(word: "text"))
    XCTAssertEqual(cell.wordLabel.text, "text")
  }
  
}

//datasource 는 provider 인데 아직 완성전이라 만든건가
extension CardCellTests {
  class FakeDataSource: NSObject, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      return UITableViewCell()
    }
  }
}
