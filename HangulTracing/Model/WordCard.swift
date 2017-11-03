//
//  WordCard.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 3..
//  Copyright © 2017년 samchon. All rights reserved.
//

import Foundation

struct WordCard {
  
  let word: String
}

extension WordCard: Equatable {
  static func ==(lhs: WordCard, rhs: WordCard) -> Bool {
    
    if lhs.word != rhs.word {
      return false
    }
    return true
  }
}
