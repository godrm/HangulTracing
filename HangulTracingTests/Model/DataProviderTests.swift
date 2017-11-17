//
//  DataProviderTests.swift
//  HangulTracingTests
//
//  Created by junwoo on 2017. 11. 9..
//  Copyright © 2017년 samchon. All rights reserved.
//

import XCTest
@testable import HangulTracing

class DataProviderTests: XCTestCase {
    
  var provider: DataProvider!
  var controller: CardListVC!
  var collectionView: UICollectionView!
  
  override func setUp() {
    super.setUp()
    controller = CardListVC()
    provider = DataProvider()
    provider.cardManager = CardManager()
    
    _ = controller.view
    collectionView = controller.collectionView
    collectionView.dataSource = provider
    collectionView.delegate = provider
    collectionView.collectionViewLayout = UICollectionViewFlowLayout()
  }
  
  override func tearDown() {
    provider.cardManager?.removeAll()
    super.tearDown()
  }
  
  //collectionview test할때 reloadData 해줘야 함
  //numberofRows
  func test_setupCard_Input6Cards() {
    XCTAssertEqual(collectionView.numberOfItems(inSection: 0), 6)
  }
  
  func test_NumberOfRowsInFirstSection_IsToDoCountPlusSetupCard() {
    let first = WordCard(word: "one", imageData: Data())
    let second = WordCard(word: "two", imageData: Data())
    provider.cardManager?.addCard(newCard: first)
    XCTAssertEqual(collectionView.numberOfItems(inSection: 0), 7)
    
    provider.cardManager?.addCard(newCard: second)
    collectionView.reloadData()
    controller.view.layoutIfNeeded()
    XCTAssertEqual(collectionView.numberOfItems(inSection: 0), 8)
  }
  
  //cellForItemAt
  func test_CellForItemAt_ReturnWordCardCell() {
    provider.cardManager?.addCard(newCard: WordCard(word: "one", imageData: Data()))
    
    collectionView.reloadData()
    controller.view.layoutIfNeeded()
    
    let cell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0))
    XCTAssertTrue(cell is WordCardCell)
    XCTAssertNotNil(cell)
  }
  
  //Dequeue (이때 cell을 register 해줘야 dequeue 가 된다)
  func test_WhenCellForItemAt_DequeueCalled() {
    let mockCollectionView = MockCollectionView.mockCollectionView(provider)
    
    provider.cardManager?.addCard(newCard: WordCard(word: "one", imageData: Data()))
    mockCollectionView.reloadData()
    mockCollectionView.layoutIfNeeded()
    
    _ = mockCollectionView.cellForItem(at: IndexPath(item: 0, section: 0))
    XCTAssertTrue(mockCollectionView.dequeueIsCalled)
  }
  
  //notification sender
  func test_SelectingACell_SendsNotification() {
    let card = WordCard(word: "one", imageData: Data())
    provider.cardManager?.addCard(newCard: card)
    
    //index가 0일 것이다
    expectation(forNotification: Constants().NOTI_CARD_SELECTED, object: nil) { (notification) -> Bool in
      guard let index = notification.userInfo?["index"] as? Int else {
        return false
      }
      return index == 0
    }
    
    //셀 클릭
    collectionView.delegate?.collectionView!(collectionView, didSelectItemAt: IndexPath(item: 0, section: 0))
    
    waitForExpectations(timeout: 3, handler: nil)
  }
}


//dequeue 호출 확인하기 위해
extension DataProviderTests {
  
  class MockCollectionView: UICollectionView {
    
    var dequeueIsCalled: Bool = false
    
    override func dequeueReusableCell(withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionViewCell {
      dequeueIsCalled = true
      return super.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    }
    
    class func mockCollectionView(_ dataSource: UICollectionViewDataSource) -> MockCollectionView {
      
      let mockCollectionView = MockCollectionView(frame: CGRect(x: 0, y: 0, width: 300, height: 600), collectionViewLayout: UICollectionViewFlowLayout())
      
      mockCollectionView.dataSource = dataSource
      mockCollectionView.register(MockCell.self, forCellWithReuseIdentifier: "WordCardCell")
      
      return mockCollectionView
    }
  }
  
  class MockCell: WordCardCell {
    
  }
  
}

