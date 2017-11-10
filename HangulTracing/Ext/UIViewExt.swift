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
}
