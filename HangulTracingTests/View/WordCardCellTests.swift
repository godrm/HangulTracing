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
  
  //wordLabel
  func test_HasWordLabel() {
    XCTAssertNotNil(cell.wordLabel)
  }
  
  //imgView
  func test_HasImgView() {
    XCTAssertNotNil(cell.imgView)
  }
  
  //configCell
  func test_ConfigCell_SetsWordLabelText() {
    let imgData = Data()
    let card = WordCard(word: "text", imageData: imgData)
    cell.configCell(card: card)
    XCTAssertEqual("text", cell.wordLabel.text)
  }
  
  func test_ConfigCell_SetsImg() {
    let imgData = Data()
    let card = WordCard(word: "temp", imageData: imgData)
    cell.configCell(card: card)
    XCTAssertEqual(UIImage(data: imgData), cell.imgView.image)
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

