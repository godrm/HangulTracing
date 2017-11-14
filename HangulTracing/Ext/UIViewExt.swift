//
//  UIViewExt.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 10..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit

extension UIView {
  var parentViewController: UIViewController? {
    var parentResponder: UIResponder? = self
    while parentResponder != nil {
      parentResponder = parentResponder!.next
      if let viewController = parentResponder as? UIViewController {
        return viewController
      }
    }
    return nil
  }
  
  func bindToKeyboard() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    
  }
  
  @objc func keyboardWillChange(_ notification: Notification) {
    let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
    let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! UInt
    let startingFrame = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
    let endingFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
    let deltaY = endingFrame.origin.y - startingFrame.origin.y
    
    UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIViewKeyframeAnimationOptions.init(rawValue: curve), animations: {
      self.frame.origin.y += deltaY
    }, completion: nil)
  }
}
