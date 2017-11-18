//
//  CellVC.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 17..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit

class CellVC: UIViewController, UIViewControllerTransitioningDelegate {
  var viewFrame: CGRect!
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
    view.backgroundColor = UIColor(hex: "FECB2F")
    return view
  }()
  var isBackViewShowing = false
  var wordLabel: UILabel = {
    let label = UILabel()
    label.backgroundColor = UIColor.clear
    label.textColor = UIColor(hex: "063796")
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
    view.backgroundColor = UIColor.clear
    
    imgView.layer.cornerRadius = 15
    imgView.clipsToBounds = true
    backView.layer.cornerRadius = 15
    backView.clipsToBounds = true
    view.addSubview(imgView)
    view.addSubview(backView)
    tracingBtn = UIButton()
    tracingBtn.backgroundColor = UIColor(hex: "063796")
    tracingBtn.setTitle("따라쓰기", for: .normal)
    tracingBtn.addTarget(self, action: #selector(CellVC.tracingBtnTapped(_:)), for: .touchUpInside)
    backView.addSubview(wordLabel)
    let dismissTap = UITapGestureRecognizer(target: self, action: #selector(CellVC.wordLBLTapped))
    wordLabel.addGestureRecognizer(dismissTap)
    wordLabel.isUserInteractionEnabled = true
    backView.addSubview(tracingBtn)
    backView.isHidden = true
    
    view.setNeedsUpdateConstraints()
  }
  
  init(viewFrame: CGRect) {
    self.viewFrame = viewFrame
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func updateViewConstraints() {
    if !didSetupConstraints {
      
      imgView.frame = viewFrame
      backView.frame = viewFrame
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
  
  func flip(completion: @escaping (_ Success: Bool) -> ()) {
    if isBackViewShowing {
      
      UIView.transition(from: backView,
                        to: imgView,
                        duration: 1.0,
                        options: [.transitionFlipFromLeft, .showHideTransitionViews],
                        completion:{ (success) in
                          completion(true)
      })
    } else {
      
      UIView.transition(from: imgView,
                        to: backView,
                        duration: 1.0,
                        options: [.transitionFlipFromRight, .showHideTransitionViews],
                        completion: { (success) in
                          completion(true)
      })
    }
    isBackViewShowing = !isBackViewShowing
  }
  
  func configView(card: WordCard) {
    wordLabel.text = card.word
    imgView.image = UIImage(data: card.imgData)
  }
  
  @objc func wordLBLTapped() {
    
    flip { (success) in
      self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
  }
  
  @objc func tracingBtnTapped(_ sender: UIButton) {
    
    guard let cardManager = cardManager else { return }
    guard let index = index else { return }
    let nextVC = TracingVC()
    nextVC.cardInfo = (cardManager, index)
    
    guard let nav = presentingViewController as? UINavigationController else { return }
    dismiss(animated: true) {
      nav.pushViewController(nextVC, animated: true)
    }
  }
}
