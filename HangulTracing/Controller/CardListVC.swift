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
  var category: Category?
  var cardManager: CardManager?
  let transition = PopAnimator()
  var cellMode: CellMode = .normal
  var dataProvider: DataProvider = {
    let provider = DataProvider()
    return provider
  }()
  
  var gameBarBtnItem: UIBarButtonItem = {
    let buttonItem = UIBarButtonItem(image: UIImage(named: "game"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(CardListVC.gameBtnTapped(_:)))
    return buttonItem
  }()
  var collectionView: UICollectionView = {
    let view = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: PinterestLayout())
    return view
  }()
  var addBtn = AddBtn()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    guard let category = category else { return }
    title = category.title
    dataProvider.cardManager = cardManager
    view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    collectionView.backgroundColor = UIColor.clear
    collectionView.register(WordCardCell.self, forCellWithReuseIdentifier: "WordCardCell")
    collectionView.dataSource = dataProvider
    collectionView.delegate = dataProvider
    if let layout = collectionView.collectionViewLayout as? PinterestLayout {
      layout.delegate = dataProvider
    }
    
    view.addSubview(collectionView)
    view.addSubview(addBtn)
    
    addBtn.addTarget(self, action: #selector(CardListVC.addBtnTapped(_:)), for: .touchUpInside)

    gameBarBtnItem.target = self
    gameBarBtnItem.action = #selector(CardListVC.gameBtnTapped(_:))
    navigationItem.rightBarButtonItem = gameBarBtnItem
    
    transition.dismissCompletion = {
      self.selectedCell?.isHidden = false
    }
    
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
      
      didSetupConstraints = true
    }
    super.updateViewConstraints()
  }
  
  @objc func addBtnTapped(_ sender: UIButton) {
    guard let category = category else { fatalError() }
    let inputVC = InputVC()
    inputVC.cardManager = self.cardManager
    inputVC.category = category
    present(inputVC, animated: true, completion: nil)
  }
  
  @objc func gameBtnTapped(_ sender: UIBarButtonItem) {
    let gameVC = GameVC()
    gameVC.cardManager = cardManager
    present(gameVC, animated: true, completion: nil)
  }
  
}

extension CardListVC: DeleteBtnDelegate {
  func deleteBtnTapped(sender: UIButton) {
    let alert = UIAlertController(title: "알림", message: "이 단어를 정말 삭제하시겠습니까?", preferredStyle: .alert)
    let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { (action) in
      if let cell = sender.superview?.superview as? WordCardCell {
        if cell.superview == self.collectionView {
          guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
          self.dataProvider.cardManager?.removeCardAt(index: indexPath.item)
          self.collectionView.reloadData()
          let layout = PinterestLayout()
          layout.delegate = self.self.dataProvider
          self.collectionView.collectionViewLayout = layout
        }
      }
    }
    let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
    alert.addAction(cancelAction)
    alert.addAction(deleteAction)
    present(alert, animated: true, completion: nil)
    
    
  }
}

extension CardListVC: UIViewControllerTransitioningDelegate {
  
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    guard let selectedCell = selectedCell as? WordCardCell else { fatalError() }
    transition.originFrame = selectedCell.convert(selectedCell.bounds, to: nil)
    
    transition.presenting = true
    selectedCell.isHidden = true
    
    return transition
  }
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    transition.presenting = false
    
    return transition
  }
}
