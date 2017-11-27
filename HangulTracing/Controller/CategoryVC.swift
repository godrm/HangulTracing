//
//  CategoryVC.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 18..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit

class CategoryVC: UIViewController {
  
  private(set) var categoryManager: CategoryManager!
  private(set) var didSetupConstraints = false
  private(set) var categoryDataProvider: CategoryDataProvider = {
    let provider = CategoryDataProvider()
    return provider
  }()
  private(set) var collectionView: UICollectionView!
  private(set) var addBtn = AddBtn()
  private(set) var editBarBtnItem: UIBarButtonItem = {
    let buttonItem = UIBarButtonItem(image: UIImage(named: "trash"), style: .plain, target: self, action: #selector(CategoryVC.editBtnTapped(_:)))
    return buttonItem
  }()
  private(set) var blockView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
    return view
  }()
  private(set) var popUpView: UIView = {
    let view = UIView()
    view.layer.cornerRadius = 15
    view.backgroundColor = UIColor(hex: "1EBBBC")
    return view
  }()
  private(set) var categoryTxtField: UITextField = {
    let txtField = UITextField()
    txtField.backgroundColor = UIColor.white
    txtField.keyboardAppearance = .dark
    txtField.keyboardType = .default
    txtField.autocorrectionType = .default
    txtField.placeholder = "카메고리명을 입력하세요"
    txtField.clearButtonMode = .whileEditing
    txtField.layer.cornerRadius = 15
    txtField.textAlignment = .center
    txtField.adjustsFontSizeToFitWidth = true
    txtField.minimumFontSize = 30
    txtField.textColor = UIColor(hex: "65418F")
    return txtField
  }()
  private(set) var cancleBtn: UIButton = {
    let btn = UIButton()
    btn.layer.cornerRadius = 15
    btn.setTitle("취소", for: .normal)
    btn.backgroundColor = UIColor(hex: "F8CF41")
    return btn
  }()
  private(set) var saveBtn: UIButton = {
    let btn = UIButton()
    btn.layer.cornerRadius = 15
    btn.setTitle("저장", for: .normal)
    btn.backgroundColor = UIColor(hex: "F35C4C")
    return btn
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    categoryDataProvider.setParentVC(vc: self)
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
    
    cancleBtn.addTarget(self, action: #selector(CategoryVC.dismissPopUp(_:)), for: .touchUpInside)
    saveBtn.addTarget(self, action: #selector(CategoryVC.saveBtnTapped(_:)), for: .touchUpInside)
    popUpView.addSubview(categoryTxtField)
    popUpView.addSubview(cancleBtn)
    popUpView.addSubview(saveBtn)
    view.addSubview(blockView)
    view.addSubview(popUpView)
    setBlockViewTap()
    blockView.isHidden = true
    popUpView.isHidden = true
    
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
      blockView.snp.makeConstraints({ (make) in
        make.edges.equalTo(self.view)
      })
      popUpView.snp.makeConstraints({ (make) in
        make.width.height.equalTo(250)
        make.centerX.equalTo(self.view)
        make.centerY.equalTo(-125)
      })
      categoryTxtField.snp.makeConstraints({ (make) in
        make.top.equalTo(popUpView).offset(50)
        make.left.equalTo(popUpView).offset(10)
        make.right.equalTo(popUpView).offset(-10)
        make.bottom.equalTo(popUpView).offset(-100)
      })
      cancleBtn.snp.makeConstraints({ (make) in
        make.top.equalTo(categoryTxtField.snp.bottom).offset(20)
        make.left.equalTo(popUpView).offset(10)
        make.bottom.equalTo(popUpView).offset(-20)
        make.right.equalTo(saveBtn.snp.left).offset(-10)
        make.width.equalTo(saveBtn)
      })
      saveBtn.snp.makeConstraints({ (make) in
        make.top.equalTo(categoryTxtField.snp.bottom).offset(20)
        make.right.equalTo(popUpView).offset(-10)
        make.bottom.equalTo(popUpView).offset(-20)
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
      cardManager.addCard(newCard: WordCard(word: "햄버거", imageData: Constants().hamburgurImgData!, category: "음식"))
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
    blockView.isHidden = false
    popUpView.isHidden = false
    
    UIView.animate(withDuration: 1.0, animations: {
      self.popUpView.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height / 2)
    }, completion: nil)
  }
  
  @objc func saveBtnTapped(_ sender: UIButton) {
    guard let text = categoryTxtField.text , !text.components(separatedBy: " ").joined(separator: "").isEmpty else { return }
    view.endEditing(true)
    categoryManager.addCategory(newCategory: Category(category: text))
    collectionView.reloadData()
    categoryTxtField.text = ""
    UIView.animate(withDuration: 1.0, animations: {
      self.popUpView.transform = .identity
    }) { (success) in
      self.blockView.isHidden = true
      self.popUpView.isHidden = true
    }
  }
  
  func setBlockViewTap() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(CategoryVC.dismissPopUp(_:)))
    blockView.addGestureRecognizer(tap)
  }
  
  @objc func dismissPopUp(_ gesture: UITapGestureRecognizer) {
    view.endEditing(true)
    UIView.animate(withDuration: 1.0, animations: {
      self.popUpView.transform = .identity
    }) { (success) in
      self.blockView.isHidden = true
      self.popUpView.isHidden = true
    }
    categoryTxtField.text = ""
  }
  
  @objc func editBtnTapped(_ sender: UIBarButtonItem) {
    if categoryDataProvider.cellMode == .normal {
      categoryDataProvider.cellMode = .delete
      navigationItem.rightBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(CategoryVC.editBtnTapped(_:)))
    } else {
      categoryDataProvider.cellMode = .normal
      navigationItem.rightBarButtonItem = editBarBtnItem
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
