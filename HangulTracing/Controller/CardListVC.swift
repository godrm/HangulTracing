//
//  CardListVC.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 8..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit

class CardListVC: UIViewController {
  private(set) var didSetupConstraints = false
  private(set) var selectedCell: WordCardCell?
  private(set) var spinner: UIActivityIndicatorView!
  private(set) var category: Category?
  private(set) var cardManager: CardManager?
  private let transition = PopAnimator()
  private(set) var cellMode: CellMode = .normal
  private(set) var dataProvider: DataProvider = {
    let provider = DataProvider()
    return provider
  }()
  
  private(set) var editBarBtnItem: UIBarButtonItem = {
    let buttonItem = UIBarButtonItem(title: "EDIT", style: UIBarButtonItemStyle.plain, target: self, action: #selector(CategoryVC.editBtnTapped(_:)))
    return buttonItem
  }()
  private(set) var collectionView: UICollectionView = {
    let view = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: PinterestLayout())
    return view
  }()
  private(set) var addBtn = AddBtn()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    dataProvider.setParentVC(vc: self)
    guard let category = category else { return }
    title = category.title
    dataProvider.cardManager = cardManager
    view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    spinner = UIActivityIndicatorView()
    spinner.color = UIColor.black
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
    view.addSubview(spinner)
    spinner.isHidden = true

    editBarBtnItem.target = self
    editBarBtnItem.action = #selector(CardListVC.editBtnTapped(_:))
    navigationItem.rightBarButtonItem = editBarBtnItem
    
    transition.dismissCompletion = {
      self.selectedCell?.isHidden = false
    }
    
    view.setNeedsUpdateConstraints()
  }
  
  func setCategoryAndManager(category: Category, manager: CardManager) {
    self.category = category
    self.cardManager = manager
  }
  
  func setSelectedCell(cell: WordCardCell) {
    self.selectedCell = cell
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
      spinner.snp.makeConstraints({ (make) in
        make.center.equalTo(self.view)
        make.width.height.equalTo(50)
      })
      didSetupConstraints = true
    }
    super.updateViewConstraints()
  }
  
  @objc func addBtnTapped(_ sender: UIButton) {
    
    let popUpBtnVC = PopUpBtnVC()
    popUpBtnVC.modalPresentationStyle = .overFullScreen
    popUpBtnVC.modalTransitionStyle = .crossDissolve
    present(popUpBtnVC, animated: true, completion: nil)
  }
  
  @objc func editBtnTapped(_ sender: UIBarButtonItem) {
    if dataProvider.cellMode == .normal {
      dataProvider.cellMode = .delete
    } else {
      dataProvider.cellMode = .normal
    }
    collectionView.reloadData()
  }
  
  func startSpinner() {
    spinner.startAnimating()
    spinner.isHidden = false
  }
  
  func stopSpinner() {
    spinner.stopAnimating()
    spinner.isHidden = true
  }
}

extension CardListVC: DeleteBtnDelegate {
  func deleteBtnTapped(sender: DeleteBtn) {
    let alert = UIAlertController(title: "알림", message: "이 단어를 정말 삭제하시겠습니까?", preferredStyle: .alert)
    let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { (action) in
      if let cell = sender.parentCell as? WordCardCell {
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

