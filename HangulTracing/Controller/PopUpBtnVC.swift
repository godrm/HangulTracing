//
//  PopUpBtnVC.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 24..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit

class PopUpBtnVC: UIViewController {
  
  private(set) var didSetupConstraints = false
  private(set) var addBtn: AddBtn!
  private(set) var btn1: AddBtn!
  private(set) var btn2: AddBtn!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
    setBgViewTap()
    
    addBtn = AddBtn()
    btn1 = AddBtn()
    btn2 = AddBtn()
    
    view.addSubview(addBtn)
    view.addSubview(btn1)
    view.addSubview(btn2)
    view.setNeedsUpdateConstraints()
  }
  
  override func updateViewConstraints() {
    if !didSetupConstraints {
      
      addBtn.snp.makeConstraints({ (make) in
        make.width.height.equalTo(70)
        make.bottom.right.equalTo(self.view).offset(-20)
      })
      
      btn1.snp.makeConstraints({ (make) in
        make.height.width.equalTo(50)
        make.centerX.equalTo(addBtn)
        make.bottom.equalTo(addBtn.snp.top).offset(-10)
      })
      
      btn2.snp.makeConstraints({ (make) in
        make.height.width.equalTo(50)
        make.centerX.equalTo(addBtn)
        make.bottom.equalTo(btn1.snp.top).offset(-10)
      })
      
      didSetupConstraints = true
    }
    super.updateViewConstraints()
  }
  
  @objc func dismissPopUp(_ gesture: UITapGestureRecognizer) {
    dismiss(animated: true, completion: nil)
  }
  
  func setBgViewTap() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(PopUpBtnVC.dismissPopUp(_:)))
    view.addGestureRecognizer(tap)
  }
  
}
