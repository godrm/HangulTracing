//
//  GameVC.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 11..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit
import CoreMotion

class GameVC: UIViewController, orientationIsOnlyLandScapeRight {
  var didSetupConstraints = false
  let interval = 0.01
  var motionManager: CMMotionManager!
  var cardManager: CardManager?
  var scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.showsVerticalScrollIndicator = false
    scrollView.isPagingEnabled = true
    scrollView.isScrollEnabled = false
    scrollView.bounces = false
    return scrollView
  }()
  var exitBtn: UIButton = {
    let btn = UIButton()
    return btn
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor.white
    view.addSubview(scrollView)
    view.addSubview(exitBtn)
    exitBtn.setImage(UIImage(named: "delete"), for: .normal)
    exitBtn.addTarget(self, action: #selector(GameVC.exitBtnTapped(_:)), for: .touchUpInside)
    view.setNeedsUpdateConstraints()
    
    motionManager = CMMotionManager()
    motionManager.deviceMotionUpdateInterval = interval
    motionManager.startDeviceMotionUpdates()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    inputCardToScrollView()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    motionManager.stopDeviceMotionUpdates()
  }
  
  override func updateViewConstraints() {
    if !didSetupConstraints {
      
      guard let cardManager = cardManager else { return }
      
      scrollView.snp.makeConstraints({ (make) in
        make.edges.equalTo(self.view)
      })
      scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * CGFloat(cardManager.toDoCount), height: UIScreen.main.bounds.height)
      
      exitBtn.snp.makeConstraints({ (make) in
        make.width.height.equalTo(100)
        make.left.top.equalTo(self.view).offset(2)
      })
      didSetupConstraints = true
    }
    super.updateViewConstraints()
  }
  
  func inputCardToScrollView() {
    guard let cardManager = cardManager else { return }
    for i in 0..<cardManager.toDoCount {
      let view = GameView(frame: CGRect(x: UIScreen.main.bounds.width * CGFloat(i), y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), word: cardManager.cardAt(index: i).word)
      scrollView.addSubview(view)
    }
  }
  
  @objc func exitBtnTapped(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }
  
  
}
