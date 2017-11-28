//
//  WordCards.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 28..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit

struct WordCards {
  
  let defaultCards: [WordCard] = [
    WordCard(word: "고양이", imageData: Constants().catImgData!, category: "동물"),
    WordCard(word: "개", imageData: Constants().dogImgData!, category: "동물"),
    WordCard(word: "오리", imageData: Constants().duckImgData!, category: "동물"),
    WordCard(word: "코끼리", imageData: Constants().elephantImgData!, category: "동물"),
    WordCard(word: "얼룩말", imageData: Constants().zebraImgData!, category: "동물"),
    WordCard(word: "기린", imageData: Constants().giraffeImgData!, category: "동물"),
    WordCard(word: "가방", imageData: Constants().bagImgData!, category: "사물"),
    WordCard(word: "김밥", imageData: Constants().kimbobImgData!, category: "음식"),
    WordCard(word: "떡볶이", imageData: Constants().ttokppokkiImgData!, category: "음식"),
    WordCard(word: "연필", imageData: Constants().pencilImgData!, category: "사물"),
    WordCard(word: "김치", imageData: Constants().kimchiImgData!, category: "음식"),
    WordCard(word: "양말", imageData: Constants().socksImgData!, category: "사물"),
    WordCard(word: "피자", imageData: Constants().pizzaImgData!, category: "음식"),
    WordCard(word: "의자", imageData: Constants().chairImgData!, category: "사물"),
    WordCard(word: "라면", imageData: Constants().ramienImgData!, category: "음식"),
    WordCard(word: "햄버거", imageData: Constants().hamburgurImgData!, category: "음식"),
    WordCard(word: "고추", imageData: Constants().pepperImgData!, category: "음식"),
    WordCard(word: "사자", imageData: Constants().lionImgData!, category: "동물"),
    WordCard(word: "호랑이", imageData: Constants().tigerImgData!, category: "동물"),
    WordCard(word: "닭", imageData: Constants().chickenImgData!, category: "동물"),
    WordCard(word: "비행기", imageData: Constants().airplaneImgData!, category: "사물"),
    WordCard(word: "모자", imageData: Constants().hatImgData!, category: "사물"),
    WordCard(word: "버스", imageData: Constants().busImgData!, category: "사물"),
    WordCard(word: "장갑", imageData: Constants().gloveImgData!, category: "사물")
  ]
  
  func setupDefaultCards() {
    let categoryManager = CategoryManager()
    categoryManager.addCategory(newCategory: Category(category: "동물"))
    categoryManager.addCategory(newCategory: Category(category: "사물"))
    categoryManager.addCategory(newCategory: Category(category: "음식"))
    
    let cardManager = CardManager(categoryTitle: "동물")
    let thingManager = CardManager(categoryTitle: "사물")
    let foodManager = CardManager(categoryTitle: "음식")
    
    if cardManager.toDoCount + thingManager.toDoCount + foodManager.toDoCount  < 20 {
      for card in defaultCards {
        cardManager.addCard(newCard: card)
      }
    }
  }
  
}
