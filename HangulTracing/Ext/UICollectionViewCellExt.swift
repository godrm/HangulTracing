//
//  UICollectionViewCellExt.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 21..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
  
  func wiggle() {
    let wiggleAnimation = CABasicAnimation(keyPath: "position")
    wiggleAnimation.duration = 0.05
    wiggleAnimation.autoreverses = true
    wiggleAnimation.repeatCount = 10000
    wiggleAnimation.fromValue = CGPoint(x: self.center.x - 1.0, y: self.center.y)
    wiggleAnimation.toValue = CGPoint(x: self.center.x + 1.0, y: self.center.y)
    layer.add(wiggleAnimation, forKey: "position")
  }
}
