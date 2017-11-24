//
//  AddBtn.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 11..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit

class AddBtn: UIButton {
  
  private struct Constants {
    static let plusLineWidth: CGFloat = 3.0
    static let plusButtonScale: CGFloat = 0.6
    static let halfPointShift: CGFloat = 0.5
  }
  
  private var halfWidth: CGFloat {
    return bounds.width / 2
  }
  
  private var halfHeight: CGFloat {
    return bounds.height / 2
  }
  
  override func draw(_ rect: CGRect) {
    let path = UIBezierPath(ovalIn: rect)
    
    UIColor(hex: "5F9EF2").setFill()
    path.fill()
    
    let plusWidth: CGFloat = min(bounds.width, bounds.height) * Constants.plusButtonScale
    let halfPlusWidth = plusWidth / 2
    
    let plusPath = UIBezierPath()
    plusPath.lineWidth = Constants.plusLineWidth
    plusPath.move(to: CGPoint(
      x: halfWidth - halfPlusWidth,
      y: halfHeight))
    
    plusPath.addLine(to: CGPoint(
      x: halfWidth + halfPlusWidth,
      y: halfHeight))
    
    plusPath.move(to: CGPoint(
      x: halfWidth + Constants.halfPointShift,
      y: halfHeight - halfPlusWidth + Constants.halfPointShift))
    
    plusPath.addLine(to: CGPoint(
      x: halfWidth + Constants.halfPointShift,
      y: halfHeight + halfPlusWidth + Constants.halfPointShift))
    
    UIColor.white.setStroke()
    plusPath.stroke()
  }
  
}
