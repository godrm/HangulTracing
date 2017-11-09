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
    let newCard = WordCard(word: "new", imageData: Data())
    sut.addCard(newCard: newCard)
    XCTAssertEqual(sut.toDoCount, 1)
  }
  
  func test_WhenSameCardAdded_NotIncreaseToDoCount() {
    let newCard = WordCard(word: "same", imageData: Data())
    let card = WordCard(word: "same", imageData: Data())
    sut.addCard(newCard: newCard)
    sut.addCard(newCard: card)
    XCTAssertEqual(sut.toDoCount, 1)
  }
  
  //cardAt
  func test_CardAt_AfterAddingCard_ReturnsThatCard() {
    let newCard = WordCard(word: "new", imageData: Data())
    sut.addCard(newCard: newCard)
    
    XCTAssertEqual(newCard.word, sut.cardAt(index: 0).word)
  }
  
  //completeCardAt
  func test_CompleteCardAt_ChangesCounts() {
    let newCard = WordCard(word: "temp", imageData: Data())
    sut.addCard(newCard: newCard)
    XCTAssertEqual(sut.toDoCount, 1)
    
    sut.completeCardAt(index: 0)
    XCTAssertEqual(sut.toDoCount, 0)
  }
  
  func test_CompleteCardAt_RemoveItFromToDoCards() {
    let first = WordCard(word: "one", imageData: Data())
    let second = WordCard(word: "two", imageData: Data())
    sut.addCard(newCard: first)
    sut.addCard(newCard: second)
    sut.completeCardAt(index: 0)
    
    XCTAssertEqual(second.word, sut.cardAt(index: 0).word)
  }
  
  //removeAll
  func test_removeAll_CountsToBeZero() {
    let first = WordCard(word: "one", imageData: Data())
    let second = WordCard(word: "two", imageData: Data())
    sut.addCard(newCard: first)
    sut.addCard(newCard: second)
    sut.completeCardAt(index: 0)
    
    sut.removeAll()
    XCTAssertEqual(sut.toDoCount, 0)
  }
}
