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
  private(set) var minusBtn: UIButton = {
    let btn = UIButton()
    btn.backgroundColor = UIColor(hex: "5F9EF2")
    btn.layer.cornerRadius = 35
    btn.setImage(UIImage(named: "minus"), for: .normal)
    return btn
  }()
  private(set) var addCardBtn: UIButton = {
    let btn = UIButton()
    btn.backgroundColor = UIColor(hex: "5F9EF2")
    btn.layer.cornerRadius = 25
    btn.setImage(UIImage(named: "addCard"), for: .normal)
    return btn
  }()
  private(set) var addCardLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.font = label.font.withSize(50)
    label.baselineAdjustment = .alignCenters
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.1
    label.textColor = UIColor.white
    label.text = "단어 추가"
    return label
  }()
  private(set) var gameBtn: UIButton = {
    let btn = UIButton()
    btn.backgroundColor = UIColor(hex: "5F9EF2")
    btn.layer.cornerRadius = 25
    btn.setImage(UIImage(named: "game"), for: .normal)
    return btn
  }()
  private(set) var gameLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.font = label.font.withSize(50)
    label.baselineAdjustment = .alignCenters
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.1
    label.textColor = UIColor.white
    label.text = "스피드퀴즈"
    return label
  }()
  private(set) var presenting = true
  private(set) var cardListVC: CardListVC!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
    setBgViewTap()
    
    minusBtn.addTarget(self, action: #selector(PopUpBtnVC.dismissPopUp(_:)), for: .touchUpInside)
    addCardBtn.addTarget(self, action: #selector(PopUpBtnVC.addCardBtnTapped(_:)), for: .touchUpInside)
    gameBtn.addTarget(self, action: #selector(PopUpBtnVC.gameBtnTapped(_:)), for: .touchUpInside)
    view.addSubview(addCardBtn)
    view.addSubview(gameBtn)
    view.addSubview(minusBtn)
    view.addSubview(addCardLabel)
    view.addSubview(gameLabel)
    addCardLabel.isHidden = true
    gameLabel.isHidden = true
    view.setNeedsUpdateConstraints()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    animateBtn { (success) in
    }
  }
  
  override func updateViewConstraints() {
    if !didSetupConstraints {
      
      minusBtn.snp.makeConstraints({ (make) in
        make.width.height.equalTo(70)
        make.bottom.right.equalTo(self.view).offset(-20)
      })
      
      addCardBtn.snp.makeConstraints({ (make) in
        make.height.width.equalTo(50)
        make.center.equalTo(minusBtn)
      })
      
      gameBtn.snp.makeConstraints({ (make) in
        make.height.width.equalTo(50)
        make.center.equalTo(minusBtn)
      })
      addCardLabel.snp.makeConstraints({ (make) in
        make.height.equalTo(20)
        make.width.equalTo(100)
        make.centerY.equalTo(addCardBtn)
        make.right.equalTo(addCardBtn.snp.left).offset(-8)
      })
      gameLabel.snp.makeConstraints({ (make) in
        make.height.equalTo(20)
        make.width.equalTo(100)
        make.centerY.equalTo(gameBtn)
        make.right.equalTo(gameBtn.snp.left).offset(-8)
      })
      didSetupConstraints = true
    }
    super.updateViewConstraints()
  }
  
  func setCardListVC(vc: CardListVC) {
    self.cardListVC = vc
  }
  
  @objc func dismissPopUp(_ gesture: UITapGestureRecognizer) {
    animateBtn { (success) in
      if success {
        self.dismiss(animated: true, completion: nil)
      }
    }
  }
  
  @objc func addCardBtnTapped(_ sender: UIButton) {
    let inputVC = InputVC()
    inputVC.setCardListVC(vc: cardListVC)
    animateBtn { (success) in
      if success {
        self.dismiss(animated: true, completion: {
          self.cardListVC.present(inputVC, animated: true, completion: nil)
        })
      }
    }
  }
  
  @objc func gameBtnTapped(_ sender: UIButton) {
    guard let cardManager = cardListVC.cardManager else { return }
    let gameVC = GameVC()
    gameVC.setCardManager(manager: cardManager)
    animateBtn { (success) in
      if success {
        self.dismiss(animated: true, completion: {
          self.cardListVC.present(gameVC, animated: true, completion: nil)
        })
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
        self.addCardBtn.transform = CGAffineTransform(translationX: 0, y: -70)
        self.gameBtn.transform = CGAffineTransform(translationX: 0, y: -130)
        self.addCardLabel.transform = CGAffineTransform(translationX: 0, y: -70)
        self.gameLabel.transform = CGAffineTransform(translationX: 0, y: -130)
        self.presenting = false
      }, completion: { (success) in
        self.addCardLabel.isHidden = false
        self.gameLabel.isHidden = false
        completion(true)
      })
    } else {
      UIView.animate(withDuration: 0.2, animations: {
        self.addCardBtn.transform = CGAffineTransform.identity
        self.gameBtn.transform = CGAffineTransform.identity
        self.addCardLabel.transform = CGAffineTransform.identity
        self.gameLabel.transform = CGAffineTransform.identity
        self.presenting = true
      }, completion: { (success) in
        self.addCardLabel.isHidden = true
        self.gameLabel.isHidden = true
        completion(true)
      })
      
    }
  }
  
}
