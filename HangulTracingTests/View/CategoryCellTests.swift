//
//  CategoryCellTests.swift
//  HangulTracingTests
//
//  Created by junwoo on 2017. 11. 22..
//  Copyright © 2017년 samchon. All rights reserved.
//

import XCTest
@testable import HangulTracing

class CategoryCellTests: XCTestCase {
  var cell: CategoryCell!
  var collectionView: UICollectionView!
  let dataSource = FakeDataSource()
  var controller: CategoryVC!
  
  override func setUp() {
    super.setUp()
    controller = CategoryVC()
    
    //viewdidload
    _ = controller.view
    collectionView = controller.collectionView
    collectionView.dataSource = dataSource
    
    //tableview와 달리 layout을 설정해줘야 함
    collectionView.collectionViewLayout = UICollectionViewFlowLayout()
    
    //dequeue
    cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: IndexPath(item: 0, section: 0)) as? CategoryCell
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func test_HasTitleLabel() {
    XCTAssertNotNil(cell.titleLabel)
  }
  
  func test_HasDeleteBtn() {
    XCTAssertNotNil(cell.deleteBtn)
  }
  
  //configCell
  func test_ConfigCell_SetsTitle() {
    let category = Category(category: "동물")
    cell.configCell(category: category, cellMode: .normal)
    XCTAssertEqual(cell.titleLabel.text, "동물")
  }
  
  func test_WhenCellModeIsDelete_DeleteBtnIsShowing() {
    let category = Category(category: "동물")
    cell.configCell(category: category, cellMode: .delete)
    XCTAssertFalse(cell.deleteBtn.isHidden)
  }
}

//datasource 는 provider 인데 아직 provider 완성전이라 임시 목객체 생성
extension CategoryCellTests {
  class FakeDataSource: NSObject, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      return UICollectionViewCell()
    }
  }
}
