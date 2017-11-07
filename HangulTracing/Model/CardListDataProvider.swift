//
//  CardListDataProvider.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 4..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit

class CardListDataProvider: NSObject {
  var cardManager: CardManager?
}

extension CardListDataProvider: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let cardManager = self.cardManager else { fatalError() }
    
    return cardManager.toDoCount
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cardManager = cardManager else { fatalError() }
    if let cell = tableView.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath) as? CardCell {
      cell.configCell(card: cardManager.cardAt(index: indexPath.row))
      return cell
    } else {
      return CardCell()
    }
  }
}

extension CardListDataProvider: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
    return "COMPLETE"
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    guard let cardManager = cardManager else { return }
    
    cardManager.completeCardAt(index: indexPath.row)
    tableView.reloadData()
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    NotificationCenter.default.post(name: Constants().NOTI_CARD_SELECTED, object: self, userInfo: ["index": indexPath.row])
  }
}
