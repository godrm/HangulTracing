//
//  PopUpVC.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 24..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit

class PopUpVC: UIViewController {
  var popUpView: UIView!
  var cardListVC: CardListVC!
  var didSetupConstraints = false
  var addCardBtn: UIButton!
  var gameBtn: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    addCardBtn = UIButton()
    addCardBtn.setTitle("+ 카드 추가", for: .normal)
    addCardBtn.backgroundColor = UIColor(hex: "292D36")
    addCardBtn.setTitleColor(UIColor.white, for: .normal)
    addCardBtn.addTarget(self, action: #selector(PopUpVC.addCardBtnTapped(_:)), for: .touchUpInside)
    
    gameBtn = UIButton()
    gameBtn.setTitle("+ 게임 시작", for: .normal)
    gameBtn.backgroundColor = UIColor(hex: "292D36")
    gameBtn.setTitleColor(UIColor.white, for: .normal)
    gameBtn.addTarget(self, action: #selector(PopUpVC.gameBtnTapped(_:)), for: .touchUpInside)
    
    popUpView = UIView()
    view.addSubview(popUpView)
    popUpView.addSubview(addCardBtn)
    popUpView.addSubview(gameBtn)
    view.setNeedsUpdateConstraints()
  }
  
  override func updateViewConstraints() {
    if !didSetupConstraints {
      popUpView.snp.makeConstraints({ (make) in
        make.edges.equalTo(self.view)
      })
      addCardBtn.snp.makeConstraints({ (make) in
        make.left.top.right.equalTo(popUpView)
        make.height.equalTo(50)
      })
      gameBtn.snp.makeConstraints({ (make) in
        make.left.bottom.right.equalTo(popUpView)
        make.top.equalTo(addCardBtn.snp.bottom)
        make.height.equalTo(50)
      })
      didSetupConstraints = true
    }
    super.updateViewConstraints()
  }
  
  @objc func addCardBtnTapped(_ sender: UIButton) {
    let inputVC = InputVC()
    inputVC.cardListVC = self.cardListVC
    dismiss(animated: true) {
      self.cardListVC.present(inputVC, animated: true, completion: nil)
    }
  }
  
  @objc func gameBtnTapped(_ sender: UIButton) {
    let gameVC = GameVC()
    gameVC.cardManager = cardListVC.cardManager
    dismiss(animated: true) {
      self.cardListVC.present(gameVC, animated: true, completion: nil)
    }
  }
}
