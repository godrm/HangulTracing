//
//  WordCard.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 3..
//  Copyright © 2017년 samchon. All rights reserved.
//

import Foundation
import RealmSwift

class WordCard: Object {
  
  @objc dynamic var word: String = ""
  convenience init(word: String) {
    self.init()
    self.word = word
    
  }
  
  override static func primaryKey() -> String? {
    return "word"
  }
}

