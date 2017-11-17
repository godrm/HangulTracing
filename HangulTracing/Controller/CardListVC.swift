//
//  CardListVC.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 8..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit

class CardListVC: UIViewController {
  var didSetupConstraints = false
  var selectedCell: WordCardCell?
  let transition = PopAnimator()
  var blurEffectView: UIVisualEffectView!
  var cellMode: CellMode = .normal
  var dataProvider: DataProvider = {
    let provider = DataProvider()
    return provider
  }()
  
  var editBarBtnItem: UIBarButtonItem = {
    let buttonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.edit, target: self, action: #selector(CardListVC.editBtnTapped(_:)))
    return buttonItem
  }()
  var gameBarBtnItem: UIBarButtonItem = {
    let buttonItem = UIBarButtonItem(image: UIImage(named: "game"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(CardListVC.gameBtnTapped(_:)))
    return buttonItem
  }()
  var collectionView: UICollectionView!
  var pinterestLayout = PinterestLayout()
  let cardManager = CardManager()
  var addBtn = AddBtn()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupCard()
    self.title = "단어장"
    view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: UICollectionViewFlowLayout())
    collectionView.backgroundColor = UIColor.clear
    collectionView.register(WordCardCell.self, forCellWithReuseIdentifier: "WordCardCell")
    view.addSubview(collectionView)
    view.addSubview(addBtn)
    collectionView.dataSource = dataProvider
    collectionView.delegate = dataProvider
    collectionView.collectionViewLayout = pinterestLayout
    if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
      layout.delegate = dataProvider
    }
    dataProvider.cardManager = cardManager
    
    addBtn.addTarget(self, action: #selector(CardListVC.addBtnTapped(_:)), for: .touchUpInside)
    editBarBtnItem.target = self
    editBarBtnItem.action = #selector(CardListVC.editBtnTapped(_:))
    navigationItem.leftBarButtonItem = editBarBtnItem
    gameBarBtnItem.target = self
    gameBarBtnItem.action = #selector(CardListVC.gameBtnTapped(_:))
    navigationItem.rightBarButtonItem = gameBarBtnItem
    
    let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
    blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    view.addSubview(blurEffectView)
    blurEffectView.isHidden = true
    view.setNeedsUpdateConstraints()
  }
  
  override func updateViewConstraints() {
    if !didSetupConstraints {
      
      collectionView.snp.makeConstraints { make in
        make.edges.equalTo(self.view)
      }
      collectionView.contentInset = UIEdgeInsets(top: 23, left: 10, bottom: 10, right: 10)
      
      addBtn.snp.makeConstraints({ (make) in
        make.width.height.equalTo(70)
        make.right.bottom.equalTo(self.view).offset(-20)
      })
      blurEffectView.snp.makeConstraints({ (make) in
        make.edges.equalTo(self.view)
      })
      didSetupConstraints = true
    }
    super.updateViewConstraints()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    collectionView.reloadData()
  }
  
  func setupCard() {
    if cardManager.toDoCount < 6 {
      cardManager.addCard(newCard: WordCard(word: "고양이", imageData: Constants().catImgData!))
      cardManager.addCard(newCard: WordCard(word: "개", imageData: Constants().dogImgData!))
      cardManager.addCard(newCard: WordCard(word: "오리", imageData: Constants().duckImgData!))
      cardManager.addCard(newCard: WordCard(word: "코끼리", imageData: Constants().elephantImgData!))
      cardManager.addCard(newCard: WordCard(word: "얼룩말", imageData: Constants().zebraImgData!))
      cardManager.addCard(newCard: WordCard(word: "기린", imageData: Constants().giraffeImgData!))
    }
  }
  
  @objc func addBtnTapped(_ sender: UIButton) {
    let inputVC = InputVC()
    inputVC.cardManager = self.cardManager
    present(inputVC, animated: true, completion: nil)
  }
  
  @objc func editBtnTapped(_ sender: UIBarButtonItem) {
    if dataProvider.cellMode == .normal {
      dataProvider.cellMode = .delete
    } else {
      dataProvider.cellMode = .normal
    }
    collectionView.reloadData()
  }
  
  @objc func gameBtnTapped(_ sender: UIBarButtonItem) {
    let gameVC = GameVC()
    gameVC.cardManager = cardManager
    present(gameVC, animated: true, completion: nil)
  }
}

extension CardListVC: DeleteBtnDelegate {
  func deleteBtnTapped(sender: UIButton) {
    
    if let cell = sender.superview?.superview as? WordCardCell {
      if cell.superview == collectionView {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        dataProvider.cardManager?.completeCardAt(index: indexPath.item)
        collectionView.reloadData()
        let layout = PinterestLayout()
        layout.delegate = dataProvider
        collectionView.collectionViewLayout = layout
      }
    }
  }
}

//extension CardListVC: UIPopoverPresentationControllerDelegate {
//  func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
//    return .none
//  }
//
//  func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
//    blurEffectView.isHidden = false
//  }
//
//  func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
//    blurEffectView.isHidden = true
//  }
//}

extension CardListVC: UIViewControllerTransitioningDelegate {
  
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    guard let selectedCell = selectedCell as? WordCardCell else { fatalError() }
    transition.originFrame = selectedCell.convert(selectedCell.frame, to: nil)
    
    transition.presenting = true
    
    return transition
  }
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    transition.presenting = false
    return transition
  }
}
