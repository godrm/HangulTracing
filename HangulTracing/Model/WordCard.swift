//
//  WordCard.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 3..
//  Copyright © 2017년 samchon. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
  @objc dynamic var title: String = ""
  
  convenience init(category: String) {
    self.init()
    self.title = category
  }
  
  override static func primaryKey() -> String? {
    return "title"
  }
}

class WordCard: Object {
  
  @objc dynamic var word: String = ""
  @objc dynamic var imgData = Data()
  @objc dynamic var category: String!
  
  convenience init(word: String, imageData: Data, category: String) {
    self.init()
    self.word = word
    self.imgData = imageData
    self.category = category
  }
  
  override static func primaryKey() -> String? {
    return "word"
  }
}

