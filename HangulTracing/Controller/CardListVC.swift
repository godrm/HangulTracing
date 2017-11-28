//
//  CardListVC.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 8..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit

class CardListVC: UIViewController {
  
  var initialTouchPoint: CGPoint = CGPoint(x: 0,y: 0)
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
  
  private(set) var collectionView: UICollectionView = {
    let view = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), collectionViewLayout: PinterestLayout())
    return view
  }()
  private(set) var showBtn: UIButton = {
    let btn = UIButton()
    btn.backgroundColor = UIColor.white
    btn.layer.cornerRadius = 35
    btn.setImage(UIImage(named: "showBtn"), for: .normal)
    return btn
  }()
  
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
    view.addSubview(showBtn)
    showBtn.addTarget(self, action: #selector(CardListVC.showBtnTapped(_:)), for: .touchUpInside)
    view.addSubview(spinner)
    spinner.isHidden = true
    
    transition.dismissCompletion = {
      self.selectedCell?.isHidden = false
    }
    
    setPanGesture()
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
      
      showBtn.snp.makeConstraints({ (make) in
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
  
  func setPanGesture() {
    
    let pan = UIPanGestureRecognizer(target: self, action: #selector(CardListVC.swipeView(_:)))
    pan.delegate = self
    collectionView.addGestureRecognizer(pan)
  }
  
  @objc func showBtnTapped(_ sender: UIButton) {
    
    let popUpBtnVC = PopUpBtnVC()
    popUpBtnVC.setParentVC(vc: self)
    popUpBtnVC.modalPresentationStyle = .overFullScreen
    popUpBtnVC.modalTransitionStyle = .crossDissolve
    present(popUpBtnVC, animated: true, completion: nil)
  }
  
  @objc func swipeView(_ recognizer: UIPanGestureRecognizer) {
    if collectionView.contentOffset.y <= -collectionView.contentInset.top {
      let touchPoint = recognizer.location(in: self.view?.window)
      if recognizer.state == UIGestureRecognizerState.began {
        initialTouchPoint = touchPoint
      } else if recognizer.state == UIGestureRecognizerState.changed {
        if touchPoint.y - initialTouchPoint.y > 0 {
          
          self.view.frame = CGRect(x: 0, y: touchPoint.y - initialTouchPoint.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
        }
      } else if recognizer.state == UIGestureRecognizerState.ended || recognizer.state == UIGestureRecognizerState.cancelled {
        if touchPoint.y - initialTouchPoint.y > 100 {
          navigationController?.popViewController(animated: true)
        } else {
          UIView.animate(withDuration: 0.3, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
          })
        }
      }
    }
  }
  
  func startSpinner() {
    spinner.startAnimating()
    spinner.isHidden = false
  }
  
  func stopSpinner() {
    spinner.stopAnimating()
    spinner.isHidden = true
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    collectionView.collectionViewLayout.invalidateLayout()
  }
  
  func presentCellVC(indexPath: IndexPath) {
    let cell = collectionView.cellForItem(at: indexPath) as! WordCardCell
    let imgHeight = cell.imgView.frame.height
    let imgWidth = cell.imgView.frame.width
    let viewWidth = UIScreen.main.bounds.width * 2 / 3
    let viewHeight = imgHeight * viewWidth / imgWidth
    let centerX = UIScreen.main.bounds.width / 2
    let centerY = UIScreen.main.bounds.height / 2
    
    let cellVC = CellVC(viewFrame: CGRect(x: centerX - viewWidth / 2, y: centerY - viewHeight / 2, width: viewWidth, height: viewHeight))
    guard let cardManager = cardManager else { return }
    cellVC.setInit(index: indexPath.item, vc: self, manager: cardManager)
    cellVC.configView(card: cardManager.cardAt(index: indexPath.item))
    cellVC.transitioningDelegate = self
    setSelectedCell(cell: cell)
    present(cellVC, animated: true) {
      cellVC.flip(completion: { (success) in
      })
    }
  }
  
  func pushTracingVC(index: Int) {
    guard let cardManager = cardManager else { return }
    let nextVC = TracingVC()
    nextVC.setCardInfo(manager: cardManager, index: index)
    navigationController?.pushViewController(nextVC, animated: true)
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
          self.dataProvider.cellMode = .normal
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

extension CardListVC: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
}
