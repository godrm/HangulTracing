//
//  CardManager.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 3..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit

class CardManager: NSObject {
  
  private var toDoCards: [WordCard] = []
  
  var toDoCount: Int { return toDoCards.count }
  
  func addCard(newCard: WordCard) {
    if !toDoCards.contains(newCard) {
      toDoCards.append(newCard)
    }
  }
  
  func cardAt(index: Int) -> WordCard {
    return toDoCards[index]
  }
  
  func completeCardAt(index: Int) {
    toDoCards.remove(at: index)
  }
  
  func removeAll() {
    toDoCards.removeAll()
  }
}
