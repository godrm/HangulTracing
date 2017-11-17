//
//  CellVC.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 17..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit

class CellVC: UIViewController, UIViewControllerTransitioningDelegate {
  var didSetupConstraints = false
  var cardManager: CardManager?
  var index: Int?
  
  var imgView: UIImageView = {
    let imgView = UIImageView()
    imgView.contentMode = .scaleAspectFill
    return imgView
  }()
  
  var backView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor(hex: "1EC545")
    return view
  }()
  var isBackViewShowing = false
  var wordLabel: UILabel = {
    let label = UILabel()
    label.backgroundColor = UIColor.clear
    label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    label.textAlignment = .center
    label.font = label.font.withSize(50)
    label.baselineAdjustment = .alignCenters
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.1
    return label
  }()
  var tracingBtn: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.layer.cornerRadius = 15
    view.layer.masksToBounds = true
    view.addSubview(imgView)
    view.addSubview(backView)
    tracingBtn = UIButton()
    tracingBtn.layer.cornerRadius = 15
    tracingBtn.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
    tracingBtn.setTitle("따라쓰기", for: .normal)
    tracingBtn.addTarget(self, action: #selector(CellVC.tracingBtnTapped(_:)), for: .touchUpInside)
    backView.addSubview(wordLabel)
    backView.addSubview(tracingBtn)
    backView.isHidden = true
    
    view.setNeedsUpdateConstraints()
  }
  
  override func updateViewConstraints() {
    if !didSetupConstraints {
      
      imgView.snp.makeConstraints { (make) in
        make.edges.equalTo(view)
      }
      backView.snp.makeConstraints { (make) in
        make.edges.equalTo(view)
      }
      tracingBtn.snp.makeConstraints({ (make) in
        make.left.bottom.right.equalTo(backView)
        make.height.equalTo(80)
      })
      wordLabel.snp.makeConstraints { (make) in
        make.top.left.right.equalTo(backView)
        make.bottom.equalTo(tracingBtn.snp.top)
      }
      
      
      didSetupConstraints = true
    }
    super.updateViewConstraints()
  }
  
  func flip() {
    if isBackViewShowing {
      
      UIView.transition(from: backView,
                        to: imgView,
                        duration: 1.0,
                        options: [.transitionFlipFromLeft, .showHideTransitionViews],
                        completion:nil)
    } else {
      
      UIView.transition(from: imgView,
                        to: backView,
                        duration: 1.0,
                        options: [.transitionFlipFromRight, .showHideTransitionViews],
                        completion: nil)
    }
    isBackViewShowing = !isBackViewShowing
  }
  
  func configView(card: WordCard) {
    wordLabel.text = card.word
    imgView.image = UIImage(data: card.imgData)
  }
  
  @objc func tracingBtnTapped(_ sender: UIButton) {
//    guard let cardManager = cardManager else { return }
//    guard let index = index else { return }
//    let nextVC = TracingVC()
//    nextVC.cardInfo = (cardManager, index)
//    guard let nav = presentingViewController as? UINavigationController else { return }
//    guard let cardListVC = nav.viewControllers.first as? CardListVC else { return }
//    dismiss(animated: true) {
//      nav.pushViewController(nextVC, animated: true)
//      cardListVC.blurEffectView.isHidden = true
//    }
    presentingViewController?.dismiss(animated: true, completion: nil)
  }
}
