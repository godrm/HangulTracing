//
//  WordCardCellTests.swift
//  HangulTracingTests
//
//  Created by junwoo on 2017. 11. 9..
//  Copyright © 2017년 samchon. All rights reserved.
//

import XCTest
@testable import HangulTracing

class WordCardCellTests: XCTestCase {
  var cell: WordCardCell!
  var collectionView: UICollectionView!
  let dataSource = FakeDataSource()
  
  override func setUp() {
    super.setUp()
    let cardListVC = CardListVC()
    
    //viewdidload
    _ = cardListVC.view
    collectionView = cardListVC.collectionView
    collectionView.dataSource = dataSource
    
    //tableview와 달리 layout을 설정해줘야 함
    collectionView.collectionViewLayout = UICollectionViewFlowLayout()
    
    //dequeue
    cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WordCardCell", for: IndexPath(item: 0, section: 0)) as? WordCardCell
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func test_HasProperty() {
    XCTAssertNotNil(cell.imgView)
    XCTAssertNotNil(cell.deleteBtn)
  }
  
  //configCell
  func test_ConfigCell_SetsImg() {
    let imgData = Data()
    let category = Category(category: "동물")
    let card = WordCard(word: "temp", imageData: imgData, category: category.title)
    cell.configCell(card: card, cellMode: .normal)
    XCTAssertEqual(UIImage(data: imgData), cell.imgView.image)
  }
  
  func test_WhenCellModeIsDelete_DeleteBtnIsShowing() {
    let imgData = Data()
    let category = Category(category: "동물")
    let card = WordCard(word: "temp", imageData: imgData, category: category.title)
    cell.configCell(card: card, cellMode: .delete)
    XCTAssertFalse(cell.deleteBtn.isHidden)
  }
  
}

//datasource 는 provider 인데 아직 provider 완성전이라 임시 목객체 생성
extension WordCardCellTests {
  class FakeDataSource: NSObject, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      return UICollectionViewCell()
    }
  }
}

