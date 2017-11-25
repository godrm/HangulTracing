//
//  PopUpBtnVC.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 24..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit
typealias CompletionHandler = (_ Success: Bool) -> ()
class PopUpBtnVC: UIViewController {
  
  private(set) var didSetupConstraints = false
  private(set) var addBtn: AddBtn!
  private(set) var btn1: AddBtn!
  private(set) var btn2: AddBtn!
  var presenting = true
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
    setBgViewTap()
    
    addBtn = AddBtn()
    btn1 = AddBtn()
    btn2 = AddBtn()
    
    view.addSubview(btn1)
    view.addSubview(btn2)
    view.addSubview(addBtn)
    
    view.setNeedsUpdateConstraints()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    animateBtn { (success) in
    }
  }
  
  override func updateViewConstraints() {
    if !didSetupConstraints {
      
      addBtn.snp.makeConstraints({ (make) in
        make.width.height.equalTo(70)
        make.bottom.right.equalTo(self.view).offset(-20)
      })
      
      btn1.snp.makeConstraints({ (make) in
        make.height.width.equalTo(50)
        make.center.equalTo(addBtn)
      })
      
      btn2.snp.makeConstraints({ (make) in
        make.height.width.equalTo(50)
        make.center.equalTo(addBtn)
      })
      
      didSetupConstraints = true
    }
    super.updateViewConstraints()
  }
  
  @objc func dismissPopUp(_ gesture: UITapGestureRecognizer) {
    animateBtn { (success) in
      if success {
        self.dismiss(animated: true, completion: nil)
      }
    }
  }
  
  func setBgViewTap() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(PopUpBtnVC.dismissPopUp(_:)))
    view.addGestureRecognizer(tap)
  }
  
  func animateBtn(completion: @escaping CompletionHandler) {
    if presenting {
      UIView.animate(withDuration: 0.2, animations: {
        self.btn1.transform = CGAffineTransform(translationX: 0, y: -70)
        self.btn2.transform = CGAffineTransform(translationX: 0, y: -130)
        self.presenting = false
      }, completion: { (success) in
        completion(true)
      })
    } else {
      UIView.animate(withDuration: 0.2, animations: {
        self.btn1.transform = CGAffineTransform.identity
        self.btn2.transform = CGAffineTransform.identity
        self.presenting = true
      }, completion: { (success) in
        completion(true)
      })
      
    }
  }
  
}
