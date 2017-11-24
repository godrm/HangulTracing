//
//  CategoryVC.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 18..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit

class CategoryVC: UIViewController {
  
  var categoryManager: CategoryManager!
  var didSetupConstraints = false
  var categoryDataProvider: CategoryDataProvider = {
    let provider = CategoryDataProvider()
    return provider
  }()
  var collectionView: UICollectionView!
  var addBtn = AddBtn()
  var editBarBtnItem: UIBarButtonItem = {
    let buttonItem = UIBarButtonItem(title: "EDIT", style: UIBarButtonItemStyle.plain, target: self, action: #selector(CategoryVC.editBtnTapped(_:)))
    return buttonItem
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    categoryManager = CategoryManager()
    categoryDataProvider.categoryManager = categoryManager
    
    setupCard()
    title = "단어장"
    view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    collectionView = UICollectionView(frame: view.frame, collectionViewLayout: UICollectionViewFlowLayout())
    collectionView.backgroundColor = UIColor.clear
    collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: "CategoryCell")
    collectionView.dataSource = categoryDataProvider
    collectionView.delegate = categoryDataProvider
    view.addSubview(collectionView)
    view.addSubview(addBtn)
    addBtn.addTarget(self, action: #selector(CategoryVC.addBtnTapped(_:)), for: .touchUpInside)
    editBarBtnItem.target = self
    editBarBtnItem.action = #selector(CategoryVC.editBtnTapped(_:))
    navigationItem.rightBarButtonItem = editBarBtnItem
    view.setNeedsUpdateConstraints()
  }
  
  override func updateViewConstraints() {
    if !didSetupConstraints {
      
      collectionView.snp.makeConstraints({ (make) in
        make.edges.equalTo(view)
      })
      
      addBtn.snp.makeConstraints({ (make) in
        make.width.height.equalTo(70)
        make.right.bottom.equalTo(self.view).offset(-20)
      })
      
      didSetupConstraints = true
    }
    super.updateViewConstraints()
  }
  
  func setupCard() {
    categoryManager.addCategory(newCategory: Category(category: "동물"))
    categoryManager.addCategory(newCategory: Category(category: "사물"))
    categoryManager.addCategory(newCategory: Category(category: "음식"))
    let cardManager = CardManager(categoryTitle: "동물")
    let thingManager = CardManager(categoryTitle: "사물")
    let foodManager = CardManager(categoryTitle: "음식")
    if cardManager.toDoCount + thingManager.toDoCount + foodManager.toDoCount  < 20 {
      cardManager.addCard(newCard: WordCard(word: "고양이", imageData: Constants().catImgData!, category: "동물"))
      cardManager.addCard(newCard: WordCard(word: "개", imageData: Constants().dogImgData!, category: "동물"))
      cardManager.addCard(newCard: WordCard(word: "오리", imageData: Constants().duckImgData!, category: "동물"))
      cardManager.addCard(newCard: WordCard(word: "코끼리", imageData: Constants().elephantImgData!, category: "동물"))
      cardManager.addCard(newCard: WordCard(word: "얼룩말", imageData: Constants().zebraImgData!, category: "동물"))
      cardManager.addCard(newCard: WordCard(word: "기린", imageData: Constants().giraffeImgData!, category: "동물"))
      cardManager.addCard(newCard: WordCard(word: "가방", imageData: Constants().bagImgData!, category: "사물"))
      cardManager.addCard(newCard: WordCard(word: "김밥", imageData: Constants().kimbobImgData!, category: "음식"))
      cardManager.addCard(newCard: WordCard(word: "떡볶이", imageData: Constants().ttokppokkiImgData!, category: "음식"))
      cardManager.addCard(newCard: WordCard(word: "연필", imageData: Constants().pencilImgData!, category: "사물"))
      cardManager.addCard(newCard: WordCard(word: "김치", imageData: Constants().kimchiImgData!, category: "음식"))
      cardManager.addCard(newCard: WordCard(word: "양말", imageData: Constants().socksImgData!, category: "사물"))
      cardManager.addCard(newCard: WordCard(word: "피자", imageData: Constants().pizzaImgData!, category: "음식"))
      cardManager.addCard(newCard: WordCard(word: "의자", imageData: Constants().chairImgData!, category: "사물"))
      cardManager.addCard(newCard: WordCard(word: "라면", imageData: Constants().ramienImgData!, category: "음식"))
      cardManager.addCard(newCard: WordCard(word: "김", imageData: Constants().gimImgData!, category: "음식"))
      cardManager.addCard(newCard: WordCard(word: "고추", imageData: Constants().pepperImgData!, category: "음식"))
      cardManager.addCard(newCard: WordCard(word: "사자", imageData: Constants().lionImgData!, category: "동물"))
      cardManager.addCard(newCard: WordCard(word: "호랑이", imageData: Constants().tigerImgData!, category: "동물"))
      cardManager.addCard(newCard: WordCard(word: "닭", imageData: Constants().chickenImgData!, category: "동물"))
      cardManager.addCard(newCard: WordCard(word: "비행기", imageData: Constants().airplaneImgData!, category: "사물"))
      cardManager.addCard(newCard: WordCard(word: "모자", imageData: Constants().hatImgData!, category: "사물"))
      cardManager.addCard(newCard: WordCard(word: "버스", imageData: Constants().busImgData!, category: "사물"))
      cardManager.addCard(newCard: WordCard(word: "장갑", imageData: Constants().gloveImgData!, category: "사물"))
    }
  }
  
  @objc func addBtnTapped(_ sender: UIButton) {
    let alert = UIAlertController(title: "카테고리 추가", message: "", preferredStyle: .alert)
    let addAction = UIAlertAction(title: "추가", style: .default) { (action) in
      guard let textFields = alert.textFields else { fatalError() }
      let titleTextField = textFields[0]
      guard let text = titleTextField.text , !text.components(separatedBy: " ").joined(separator: "").isEmpty else { return }
      self.categoryManager.addCategory(newCategory: Category(category: text))
      self.collectionView.reloadData()
    }
    let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
    alert.addTextField { (textField) in
      textField.keyboardAppearance = .dark
      textField.keyboardType = .default
      textField.autocorrectionType = .default
      textField.placeholder = "카메고리명을 입력하세요"
      textField.clearButtonMode = .whileEditing
    }
    
    alert.addAction(cancelAction)
    alert.addAction(addAction)
    present(alert, animated: true, completion: nil)
  }
  
  @objc func editBtnTapped(_ sender: UIBarButtonItem) {
    if categoryDataProvider.cellMode == .normal {
      categoryDataProvider.cellMode = .delete
    } else {
      categoryDataProvider.cellMode = .normal
    }
    collectionView.reloadData()
  }

}

extension CategoryVC: DeleteBtnDelegate {
  func deleteBtnTapped(sender: DeleteBtn) {
    let alert = UIAlertController(title: "알림", message: "해당 카테고리의 단어들이 모두 삭제됩니다. 정말 삭제하시겠습니까?", preferredStyle: .alert)
    let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { (action) in
      if let cell = sender.parentCell as? CategoryCell {
        if cell.superview == self.collectionView {
          guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
          self.categoryDataProvider.categoryManager?.removeCategoryAt(index: indexPath.item)
          self.collectionView.reloadData()
        }
      }
    }
    let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
    alert.addAction(cancelAction)
    alert.addAction(deleteAction)
    present(alert, animated: true, completion: nil)
  }
}
