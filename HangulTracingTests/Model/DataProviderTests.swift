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
    controller.setCategoryAndManager(category: Category(category: ""), manager: CardManager(categoryTitle: ""))
    
    provider = DataProvider()
    provider.cardManager = CardManager(categoryTitle: "")
    
    _ = controller.view
    collectionView = controller.collectionView
    collectionView.dataSource = provider
    collectionView.delegate = provider
    collectionView.collectionViewLayout = UICollectionViewFlowLayout()
  }
  
  override func tearDown() {
    provider.cardManager?.makeRealmEmpty()
    super.tearDown()
  }
  
  //collectionview test할때 reloadData 해줘야 함
  
  func test_HasCellMode() {
    XCTAssertNotNil(provider.cellMode)
  }
  
  func test_HasAudioPlayer() {
    XCTAssertNotNil(provider.audioPlayer)
  }
  
  //numberofitems
  func test_NumberOfRowsInFirstSection_IsToDoCountPlusSetupCard() {
    let category = Category(category: "")
    let first = WordCard(word: "one", imageData: Data(), category: category.title)
    let second = WordCard(word: "two", imageData: Data(), category: category.title)
    provider.cardManager?.addCard(newCard: first)
    XCTAssertEqual(collectionView.numberOfItems(inSection: 0), 1)
    
    provider.cardManager?.addCard(newCard: second)
    collectionView.reloadData()
    controller.view.layoutIfNeeded()
    XCTAssertEqual(collectionView.numberOfItems(inSection: 0), 2)
  }
  
  //cellForItemAt
  func test_CellForItemAt_ReturnWordCardCell() {
    let category = Category(category: "")
    provider.cardManager?.addCard(newCard: WordCard(word: "one", imageData: Data(), category: category.title))
    
    collectionView.reloadData()
    controller.view.layoutIfNeeded()
    
    let cell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0))
    XCTAssertTrue(cell is WordCardCell)
    XCTAssertNotNil(cell)
  }
  
  //Dequeue (이때 cell을 register 해줘야 dequeue 가 된다)
  func test_WhenCellForItemAt_DequeueCalled() {
    let mockCollectionView = MockCollectionView.mockCollectionView(provider)
    let category = Category(category: "")
    provider.cardManager?.addCard(newCard: WordCard(word: "one", imageData: Data(), category: category.title))
    mockCollectionView.reloadData()
    mockCollectionView.layoutIfNeeded()
    
    _ = mockCollectionView.cellForItem(at: IndexPath(item: 0, section: 0))
    XCTAssertTrue(mockCollectionView.dequeueIsCalled)
  }
  
  func test_WhenSelectingCell_presentCellVC() {
    UIApplication.shared.keyWindow?.rootViewController = controller
    
    let category = Category(category: "")
    provider.cardManager?.addCard(newCard: WordCard(word: "one", imageData: Data(), category: category.title))
    
    collectionView.reloadData()
    controller.view.layoutIfNeeded()
    
    collectionView.delegate?.collectionView!(collectionView, didSelectItemAt: IndexPath(item: 0, section: 0))
    XCTAssertTrue(controller.presentedViewController is CellVC)
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

