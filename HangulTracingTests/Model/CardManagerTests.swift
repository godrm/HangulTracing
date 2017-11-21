//
//  CardManagerTests.swift
//  HangulTracingTests
//
//  Created by junwoo on 2017. 11. 3..
//  Copyright © 2017년 samchon. All rights reserved.
//

import XCTest
import RealmSwift
@testable import HangulTracing

class CardManagerTests: XCTestCase {
  var testRealm: Realm!
  var sut: CardManager!
  
  override func setUp() {
    super.setUp()
    testRealm = try! Realm()
    sut = CardManager()
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
  
  //toDoCount
  func test_ToDoCount_Initially_SameAsRealmObjectsCount() {
    XCTAssertEqual(sut.toDoCount, sut.realm.objects(WordCard.self).count)
  }
  
  //addCard
  func test_AddCard_IncreaseToDoCountToOne() {
    let category = Category(category: "동물")
    let newCard = WordCard(word: "test", imageData: Data(), category: category.title)
    sut.addCard(newCard: newCard)
    XCTAssertEqual(sut.toDoCount, 1)
  }
  
  func test_WhenSameCardAdded_NotIncreaseToDoCount() {
    let category = Category(category: "동물")
    let newCard = WordCard(word: "same", imageData: Data(), category: category.title)
    let card = WordCard(word: "same", imageData: Data(), category: category.title)
    sut.addCard(newCard: newCard)
    sut.addCard(newCard: card)
    XCTAssertEqual(sut.toDoCount, 1)
  }
  
  //cardAt
  func test_CardAt_AfterAddingCard_ReturnsThatCard() {
    let category = Category(category: "동물")
    let newCard = WordCard(word: "same", imageData: Data(), category: category.title)
    sut.addCard(newCard: newCard)
    
    XCTAssertEqual(newCard.word, sut.cardAt(index: 0).word)
  }
  
  //completeCardAt
  func test_CompleteCardAt_ChangesCounts() {
    let category = Category(category: "동물")
    let newCard = WordCard(word: "same", imageData: Data(), category: category.title)
    sut.addCard(newCard: newCard)
    XCTAssertEqual(sut.toDoCount, 1)
    
    sut.removeCardAt(index: 0)
    XCTAssertEqual(sut.toDoCount, 0)
  }
  
  func test_CompleteCardAt_RemoveItFromToDoCards() {
    let category = Category(category: "동물")
    let first = WordCard(word: "one", imageData: Data(), category: category.title)
    let second = WordCard(word: "two", imageData: Data(), category: category.title)
    sut.addCard(newCard: first)
    sut.addCard(newCard: second)
    sut.removeCardAt(index: 0)
    
    XCTAssertEqual(second.word, sut.cardAt(index: 0).word)
  }
  
  //removeAll
  func test_removeAll_CountsToBeZero() {
    let category = Category(category: "동물")
    let first = WordCard(word: "one", imageData: Data(), category: category.title)
    let second = WordCard(word: "two", imageData: Data(), category: category.title)
    sut.addCard(newCard: first)
    sut.addCard(newCard: second)
    sut.removeCardAt(index: 0)
    
    sut.removeAll()
    XCTAssertEqual(sut.toDoCount, 0)
  }
}
