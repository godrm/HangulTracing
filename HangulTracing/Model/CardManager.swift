//
//  CardManager.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 3..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit
import RealmSwift

class CardManager: NSObject {
  
  var realm: Realm!
  var toDoCards: Results<WordCard>!
  var toDoCount: Int { return toDoCards.count }
  var categoryTitle: String!
  
  convenience init(categoryTitle: String) {
    self.init()
    self.categoryTitle = categoryTitle
    realm = try! Realm()
    toDoCards = realm.objects(WordCard.self).filter("category = %@", categoryTitle)
  }
  
  func addCard(newCard: WordCard) {
    let myPrimaryKey = newCard.word
    if realm.object(ofType: WordCard.self, forPrimaryKey: myPrimaryKey) == nil {
      try! realm.write {
        realm.add(newCard)
      }
    }
  }
  
  func cardAt(index: Int) -> WordCard {
    return toDoCards[index]
  }
  
  func removeCardAt(index: Int) {
    try! realm.write {
      realm.delete(toDoCards[index])
    }
  }
  
  func removeAll() {
    try! realm.write {
      realm.delete(toDoCards)
    }
  }
}
