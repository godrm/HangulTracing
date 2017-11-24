//
//  CellVC.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 17..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit

class CellVC: UIViewController, UIViewControllerTransitioningDelegate {
  private(set) var viewFrame: CGRect!
  private(set) var cardListVC: CardListVC!
  private(set) var didSetupConstraints = false
  private(set) var cardManager: CardManager?
  private(set) var index: Int?
  private(set) var imgView: UIImageView = {
    let imgView = UIImageView()
    imgView.contentMode = .scaleAspectFill
    imgView.layer.cornerRadius = 15
    imgView.clipsToBounds = true
    return imgView
  }()
  private(set) var audioPlayer = SoundPlayer()
  private(set) var backView: UIView = {
    let view = UIView()
    view.layer.cornerRadius = 15
    view.clipsToBounds = true
    view.backgroundColor = UIColor(hex: "FED230")
    return view
  }()
  private(set) var isBackViewShowing = false
  private(set) var wordLabel: UILabel = {
    let label = UILabel()
    label.backgroundColor = UIColor.clear
    label.textColor = UIColor(hex: "65418F")
    label.textAlignment = .center
    label.font = label.font.withSize(50)
    label.baselineAdjustment = .alignCenters
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.1
    return label
  }()
  private(set) var tracingBtn: UIButton = {
    let btn = UIButton()
    btn.layer.cornerRadius = 15
    btn.setImage(UIImage(named: "tracing"), for: .normal)
    return btn
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.clear
    view.addSubview(imgView)
    view.addSubview(backView)
    
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
  
  func setInit(index: Int, vc: CardListVC, manager: CardManager) {
    self.index = index
    self.cardListVC = vc
    self.cardManager = manager
  }
  
  override func updateViewConstraints() {
    if !didSetupConstraints {
      
      imgView.frame = viewFrame
      backView.frame = viewFrame
      wordLabel.snp.makeConstraints({ (make) in
        make.edges.equalTo(backView)
      })
      tracingBtn.snp.makeConstraints { (make) in
        make.top.right.equalTo(backView)
        make.width.height.equalTo(50)
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
                          self.animateTracingBtn()
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
    guard let nav = cardListVC.navigationController else { return }
    flip { (success) in
      nav.dismiss(animated: true, completion: nil)
    }
  }
  
  @objc func tracingBtnTapped(_ sender: UIButton) {
    cardListVC.startSpinner()
    guard let nav = cardListVC.navigationController else { return }
    guard let cardManager = cardManager else { return }
    guard let index = index else { return }
    audioPlayer.playSoundEffect(name: "writing", extender: "mp3")
    let nextVC = TracingVC()
    nextVC.setCardInfo(manager: cardManager, index: index)
    dismiss(animated: true) {
      nav.pushViewController(nextVC, animated: true)
      self.cardListVC.stopSpinner()
    }
    
  }
  
  func animateTracingBtn() {
    tracingBtn.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
    UIView.animate(withDuration: 2.0, delay: 0, usingSpringWithDamping: 0.2,
                   initialSpringVelocity: 6.0, options: .allowUserInteraction,
                   animations: { [weak self] in
                    self?.tracingBtn.transform = .identity
                  }, completion: { (finished) in
                      self.animateTracingBtn()
                  })
  }
  
}
