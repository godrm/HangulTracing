//
//  CategoryVC.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 18..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit

class CategoryVC: UIViewController {
  let transition = PopAnimator()
  private(set) var selectedCell: CategoryCell?
  private(set) var categoryManager: CategoryManager!
  private(set) var didSetupConstraints = false
  private(set) var categoryDataProvider: CategoryDataProvider = {
    let provider = CategoryDataProvider()
    return provider
  }()
  private(set) var collectionView: UICollectionView!
  private(set) var showBtn: UIButton = {
    let btn = UIButton()
    btn.backgroundColor = UIColor.white
    btn.layer.cornerRadius = 35
    btn.setImage(UIImage(named: "showBtn"), for: .normal)
    return btn
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "단어장"
    categoryDataProvider.setParentVC(vc: self)
    categoryManager = CategoryManager()
    categoryDataProvider.categoryManager = categoryManager
    
    WordCards().setupDefaultCards()
    view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    collectionView = UICollectionView(frame: view.frame, collectionViewLayout: UICollectionViewFlowLayout())
    collectionView.backgroundColor = UIColor.clear
    collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: "CategoryCell")
    collectionView.dataSource = categoryDataProvider
    collectionView.delegate = categoryDataProvider
    view.addSubview(collectionView)
    view.addSubview(showBtn)
    showBtn.addTarget(self, action: #selector(CategoryVC.showBtnTapped(_:)), for: .touchUpInside)
    
    navigationController?.delegate = self
    navigationController?.setNavigationBarHidden(true, animated: true)
    view.setNeedsUpdateConstraints()
  }
  
  override func updateViewConstraints() {
    if !didSetupConstraints {
      
      collectionView.snp.makeConstraints({ (make) in
        make.edges.equalTo(view)
      })
      
      showBtn.snp.makeConstraints({ (make) in
        make.width.height.equalTo(70)
        make.right.bottom.equalTo(self.view).offset(-20)
      })
      
      didSetupConstraints = true
    }
    super.updateViewConstraints()
  }
  
  func setSelectedCell(cell: CategoryCell) {
    self.selectedCell = cell
  }
  
  func pushCardListVC(indexPath: IndexPath) {
    let category = categoryManager.categories[indexPath.item]
    let cardListVC = CardListVC()
    cardListVC.setCategoryAndManager(category: category, manager: CardManager(categoryTitle: category.title))
    
    cardListVC.transitioningDelegate = self
    
    let cell = collectionView.cellForItem(at: indexPath) as! CategoryCell
    setSelectedCell(cell: cell)
    navigationController?.pushViewController(cardListVC, animated: true)
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    collectionView.collectionViewLayout.invalidateLayout()
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
          self.categoryDataProvider.cellMode = .normal
          self.collectionView.reloadData()
        }
      }
    }
    let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
    alert.addAction(cancelAction)
    alert.addAction(deleteAction)
    present(alert, animated: true, completion: nil)
  }
  
  @objc func showBtnTapped(_ sender: UIButton) {
    
    let popUpBtnVC = PopUpBtnVC()
    popUpBtnVC.setParentVC(vc: self)
    popUpBtnVC.modalPresentationStyle = .overFullScreen
    popUpBtnVC.modalTransitionStyle = .crossDissolve
    present(popUpBtnVC, animated: true, completion: nil)
  }
}

extension CategoryVC: UIViewControllerTransitioningDelegate {
}

extension CategoryVC: UINavigationControllerDelegate {
  func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    
    //push
    if fromVC is CategoryVC, toVC is CardListVC {
      guard let selectedCell = selectedCell as? CategoryCell else { fatalError() }
      transition.originFrame = selectedCell.convert(selectedCell.bounds, to: nil)
      transition.presenting = true
      return transition
    }
    //pop
    else if fromVC is CardListVC, toVC is CategoryVC {
      transition.presenting = false
      return transition
    }
    return nil
  }
  
}
