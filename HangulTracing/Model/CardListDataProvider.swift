//
//  CardListDataProvider.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 4..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit

enum Section: Int {
  case toDo
  case done
  static let arr = [toDo, done]
}

class CardListDataProvider: NSObject {
  var cardManager: CardManager?
}

extension CardListDataProvider: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return Section.arr.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let cardManager = cardManager else { return 0 }
    guard let cardSection = Section(rawValue: section) else { fatalError() }
    
    var numberOfRows: Int = 0
    switch cardSection {
    case .toDo: numberOfRows = cardManager.toDoCount
    case .done: numberOfRows = cardManager.doneCount
    }
    
    return numberOfRows
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath) as? CardCell {
      return cell
    } else {
      return CardCell()
    }
  }
}

extension CardListDataProvider: UITableViewDelegate {
  
}
