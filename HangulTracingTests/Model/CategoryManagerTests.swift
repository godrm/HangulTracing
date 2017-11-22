//
//  CategoryManagerTests.swift
//  HangulTracingTests
//
//  Created by junwoo on 2017. 11. 22..
//  Copyright © 2017년 samchon. All rights reserved.
//

import XCTest
import RealmSwift
@testable import HangulTracing

class CategoryManagerTests: XCTestCase {
  var testRealm: Realm!
  var sut: CategoryManager!
  
  override func setUp() {
    super.setUp()
    testRealm = try! Realm()
    sut = CategoryManager()
    sut.realm = testRealm
    
    try! sut.realm.write {
      sut.realm.deleteAll()
    }
  }
  
  override func tearDown() {
    try! sut.realm.write {
      sut.realm.deleteAll()
    }
    sut = nil
    super.tearDown()
  }
  
  func test_addCategory_IncreaseCount() {
    XCTAssertEqual(sut.categories.count, 0)
    let newCategory = Category(category: "new")
    sut.addCategory(newCategory: newCategory)
    XCTAssertEqual(sut.categories.count, 1)
  }
  
  func test_WhenaddSameCategory_DoNotIncreaseCount() {
    let newCategory = Category(category: "new")
    sut.addCategory(newCategory: newCategory)
    XCTAssertEqual(sut.categories.count, 1)
    sut.addCategory(newCategory: newCategory)
    XCTAssertEqual(sut.categories.count, 1)
  }
  
  func test_categoryAt_ReturnCorrectCategory() {
    let first = Category(category: "first")
    let second = Category(category: "second")
    sut.addCategory(newCategory: first)
    sut.addCategory(newCategory: second)
    XCTAssertEqual(sut.categoryAt(index: 0).title, "first")
    XCTAssertEqual(sut.categoryAt(index: 1).title, "second")
  }
  
  func test_removeCategoryAt_removeFromCategories() {
    let first = Category(category: "first")
    let second = Category(category: "second")
    sut.addCategory(newCategory: first)
    sut.addCategory(newCategory: second)
    XCTAssertTrue(sut.categories.contains(first))
    sut.removeCategoryAt(index: 0)
    XCTAssertFalse(sut.categories.contains(first))
  }
  
  func test_removeAll_makeCategoriesEmpty() {
    let first = Category(category: "first")
    let second = Category(category: "second")
    sut.addCategory(newCategory: first)
    sut.addCategory(newCategory: second)
    XCTAssertEqual(sut.categories.count, 2)
    sut.removeAll()
    XCTAssertEqual(sut.categories.count, 0)
  }
}
