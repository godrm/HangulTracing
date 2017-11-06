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
  private var doneCards: [WordCard] = []
  var toDoCount: Int { return toDoCards.count }
  var doneCount: Int { return doneCards.count }
  
  func addCard(newCard: WordCard) {
    if !toDoCards.contains(newCard) {
      toDoCards.append(newCard)
    }
  }
  
  func cardAt(index: Int) -> WordCard {
    return toDoCards[index]
  }
  
  func completeCardAt(index: Int) {
    let completedCard = toDoCards.remove(at: index)
    doneCards.append(completedCard)
  }
  
  func resetCardAt(index: Int) {
    let resetCard = doneCards.remove(at: index)
    toDoCards.append(resetCard)
  }
  
  func doneCardsAt(index: Int) -> WordCard {
    return doneCards[index]
  }
  
  func removeAll() {
    toDoCards.removeAll()
    doneCards.removeAll()
  }
}
