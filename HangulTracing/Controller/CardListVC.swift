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
  var cellMode: CellMode = .normal
  var dataProvider: DataProvider = {
    let provider = DataProvider()
    return provider
  }()
  var addBarBtnItem: UIBarButtonItem = {
    let buttonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(CardListVC.addBtnTapped(_:)))
    return buttonItem
  }()
  var editBarBtnItem: UIBarButtonItem = {
    let buttonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.edit, target: self, action: #selector(CardListVC.editBtnTapped(_:)))
    return buttonItem
  }()
  var collectionView: UICollectionView!
  var pinterestLayout = PinterestLayout()
  let cardManager = CardManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "단어장"
    NotificationCenter.default.addObserver(self, selector: #selector(CardListVC.pushTracingVC(_:)), name: Constants().NOTI_CARD_SELECTED, object: nil)
    view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: UICollectionViewFlowLayout())
    collectionView.backgroundColor = UIColor.clear
    collectionView.register(WordCardCell.self, forCellWithReuseIdentifier: "WordCardCell")
    view.addSubview(collectionView)
    collectionView.dataSource = dataProvider
    collectionView.delegate = dataProvider
    collectionView.collectionViewLayout = pinterestLayout
    if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
      layout.delegate = dataProvider
    }
    dataProvider.cardManager = cardManager
    
    addBarBtnItem.target = self
    addBarBtnItem.action = #selector(CardListVC.addBtnTapped(_:))
    navigationItem.rightBarButtonItem = addBarBtnItem
    editBarBtnItem.target = self
    editBarBtnItem.action = #selector(CardListVC.editBtnTapped(_:))
    navigationItem.leftBarButtonItem = editBarBtnItem
    
    view.setNeedsUpdateConstraints()
  }
  
  override func updateViewConstraints() {
    if !didSetupConstraints {
      
      collectionView.snp.makeConstraints { make in
        make.edges.equalTo(self.view)
      }
      collectionView.contentInset = UIEdgeInsets(top: 23, left: 10, bottom: 10, right: 10)
      didSetupConstraints = true
    }
    super.updateViewConstraints()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    collectionView.reloadData()
  }
  
  @objc func addBtnTapped(_ sender: UIBarButtonItem) {
    let inputVC = InputVC()
    inputVC.cardManager = self.cardManager
    present(inputVC, animated: true, completion: nil)
  }
  
  @objc func pushTracingVC(_ notification: NSNotification) {
    guard let index = notification.userInfo!["index"] as? Int else { fatalError() }
    let nextVC = TracingVC()
    nextVC.cardInfo = (cardManager, index)
    navigationController?.pushViewController(nextVC, animated: true)
  }
  @objc func editBtnTapped(_ sender: UIBarButtonItem) {
    if dataProvider.cellMode == .normal {
      dataProvider.cellMode = .delete
    } else {
      dataProvider.cellMode = .normal
    }
    collectionView.reloadData()
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
