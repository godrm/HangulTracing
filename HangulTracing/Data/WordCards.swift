//
//  WordCards.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 28..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit

struct WordCards {
  
  //imgData
  let catImgData = UIImageJPEGRepresentation((UIImage(named: "cat")?.downSizeImageWith(downRatio: 0.1))!, 1)
  let dogImgData = UIImageJPEGRepresentation((UIImage(named: "dog")?.downSizeImageWith(downRatio: 0.1))!, 1)
  let giraffeImgData = UIImageJPEGRepresentation((UIImage(named: "giraffe")?.downSizeImageWith(downRatio: 0.1))!, 1)
  let elephantImgData = UIImageJPEGRepresentation((UIImage(named: "elephant")?.downSizeImageWith(downRatio: 0.1))!, 1)
  let zebraImgData = UIImageJPEGRepresentation((UIImage(named: "zebra")?.downSizeImageWith(downRatio: 0.1))!, 1)
  let duckImgData = UIImageJPEGRepresentation((UIImage(named: "duck")?.downSizeImageWith(downRatio: 0.1))!, 1)
  let bagImgData = UIImageJPEGRepresentation((UIImage(named: "bag")?.downSizeImageWith(downRatio: 0.1))!, 1)
  let chairImgData = UIImageJPEGRepresentation((UIImage(named: "chair")?.downSizeImageWith(downRatio: 0.1))!, 1)
  let kimbobImgData = UIImageJPEGRepresentation((UIImage(named: "kimbob")?.downSizeImageWith(downRatio: 0.1))!, 1)
  let kimchiImgData = UIImageJPEGRepresentation((UIImage(named: "kimchi")?.downSizeImageWith(downRatio: 0.1))!, 1)
  let pencilImgData = UIImageJPEGRepresentation((UIImage(named: "pencil")?.downSizeImageWith(downRatio: 0.1))!, 1)
  let pizzaImgData = UIImageJPEGRepresentation((UIImage(named: "pizza")?.downSizeImageWith(downRatio: 0.1))!, 1)
  let ttokppokkiImgData = UIImageJPEGRepresentation((UIImage(named: "ttokppokki")?.downSizeImageWith(downRatio: 0.1))!, 1)
  let socksImgData = UIImageJPEGRepresentation((UIImage(named: "socks")?.downSizeImageWith(downRatio: 0.1))!, 1)
  let chickenImgData = UIImageJPEGRepresentation((UIImage(named: "chicken")?.downSizeImageWith(downRatio: 0.1))!, 1)
  let hamburgurImgData = UIImageJPEGRepresentation((UIImage(named: "hamburgur")?.downSizeImageWith(downRatio: 0.1))!, 1)
  let lionImgData = UIImageJPEGRepresentation((UIImage(named: "lion")?.downSizeImageWith(downRatio: 0.1))!, 1)
  let ramienImgData = UIImageJPEGRepresentation((UIImage(named: "ramien")?.downSizeImageWith(downRatio: 0.1))!, 1)
  let tigerImgData = UIImageJPEGRepresentation((UIImage(named: "tiger")?.downSizeImageWith(downRatio: 0.1))!, 1)
  let pepperImgData = UIImageJPEGRepresentation((UIImage(named: "pepper")?.downSizeImageWith(downRatio: 0.1))!, 1)
  let airplaneImgData = UIImageJPEGRepresentation((UIImage(named: "airplane")?.downSizeImageWith(downRatio: 0.1))!, 1)
  let busImgData = UIImageJPEGRepresentation((UIImage(named: "bus")?.downSizeImageWith(downRatio: 0.1))!, 1)
  let hatImgData = UIImageJPEGRepresentation((UIImage(named: "hat")?.downSizeImageWith(downRatio: 0.1))!, 1)
  let gloveImgData = UIImageJPEGRepresentation((UIImage(named: "glove")?.downSizeImageWith(downRatio: 0.1))!, 1)
  
  func getDefaultCards() -> [WordCard] {
    return [
      WordCard(word: "고양이", imageData: catImgData!, category: "동물"),
      WordCard(word: "개", imageData: dogImgData!, category: "동물"),
      WordCard(word: "오리", imageData: duckImgData!, category: "동물"),
      WordCard(word: "코끼리", imageData: elephantImgData!, category: "동물"),
      WordCard(word: "얼룩말", imageData: zebraImgData!, category: "동물"),
      WordCard(word: "기린", imageData: giraffeImgData!, category: "동물"),
      WordCard(word: "가방", imageData: bagImgData!, category: "사물"),
      WordCard(word: "김밥", imageData: kimbobImgData!, category: "음식"),
      WordCard(word: "떡볶이", imageData: ttokppokkiImgData!, category: "음식"),
      WordCard(word: "연필", imageData: pencilImgData!, category: "사물"),
      WordCard(word: "김치", imageData: kimchiImgData!, category: "음식"),
      WordCard(word: "양말", imageData: socksImgData!, category: "사물"),
      WordCard(word: "피자", imageData: pizzaImgData!, category: "음식"),
      WordCard(word: "의자", imageData: chairImgData!, category: "사물"),
      WordCard(word: "라면", imageData: ramienImgData!, category: "음식"),
      WordCard(word: "햄버거", imageData: hamburgurImgData!, category: "음식"),
      WordCard(word: "고추", imageData: pepperImgData!, category: "음식"),
      WordCard(word: "사자", imageData: lionImgData!, category: "동물"),
      WordCard(word: "호랑이", imageData: tigerImgData!, category: "동물"),
      WordCard(word: "닭", imageData: chickenImgData!, category: "동물"),
      WordCard(word: "비행기", imageData: airplaneImgData!, category: "사물"),
      WordCard(word: "모자", imageData: hatImgData!, category: "사물"),
      WordCard(word: "버스", imageData: busImgData!, category: "사물"),
      WordCard(word: "장갑", imageData: gloveImgData!, category: "사물")
    ]
  }
  
  func setupDefaultCards() {
    let categoryManager = CategoryManager()
    categoryManager.addCategory(newCategory: Category(category: "동물"))
    categoryManager.addCategory(newCategory: Category(category: "사물"))
    categoryManager.addCategory(newCategory: Category(category: "음식"))
    
    let cardManager = CardManager.instance
    let defaultCards = getDefaultCards()
    
    if cardManager.toDoCount < 20 {
      for card in defaultCards {
        cardManager.addCard(newCard: card)
      }
    }
  }
  
}
