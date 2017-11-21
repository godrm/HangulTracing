//
//  UICollectionViewCellExt.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 21..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit

extension UICollectionViewCell: UIGestureRecognizerDelegate {
  
  func wiggle() {
    let wiggleAnimation = CABasicAnimation(keyPath: "position")
    wiggleAnimation.duration = 0.05
    wiggleAnimation.autoreverses = true
    wiggleAnimation.repeatCount = 10000
    wiggleAnimation.fromValue = CGPoint(x: self.center.x - 4.0, y: self.center.y)
    wiggleAnimation.toValue = CGPoint(x: self.center.x + 4.0, y: self.center.y)
    layer.add(wiggleAnimation, forKey: "position")
  }
  
  func addLongPressGesture() {
    let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
    self.addGestureRecognizer(longPress)
  }
  
  @objc func handleLongPress(_ gestureReconizer: UILongPressGestureRecognizer) {
    if gestureReconizer.state != UIGestureRecognizerState.ended {
      return
    }
    if let collectionView = self.superview as? UICollectionView {
      if let cardListVC = collectionView.parentViewController as? CardListVC {
        if cardListVC.dataProvider.cellMode == .normal {
          cardListVC.dataProvider.cellMode = .delete
        } else {
          cardListVC.dataProvider.cellMode = .normal
        }
      }
      else if let categoryVC = collectionView.parentViewController as? CategoryVC {
        if categoryVC.categoryDataProvider.cellMode == .normal {
          categoryVC.categoryDataProvider.cellMode = .delete
        } else {
          categoryVC.categoryDataProvider.cellMode = .normal
        }
      }
      collectionView.reloadData()
    }
    
  }
}
