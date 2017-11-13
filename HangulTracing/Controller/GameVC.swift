//
//  GameVC.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 11..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit
import CoreMotion
import AVFoundation

class GameVC: UIViewController, orientationIsOnlyLandScapeRight {
  var didSetupConstraints = false
  var speechSynthesizer: AVSpeechSynthesizer!
  var blurEffectView: UIVisualEffectView!
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
  var startView: GameView!
  var greatCount: Int!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    greatCount = 0
    speechSynthesizer = AVSpeechSynthesizer()
    view.backgroundColor = UIColor.white
    view.addSubview(scrollView)
    
    let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
    blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    view.addSubview(blurEffectView)
    blurEffectView.isHidden = true
    
    startView = GameView(frame: CGRect(), word: "핸드폰 들어!")
    startView.exitBtnDelegate = self
    view.addSubview(startView)
    
    motionManager = CMMotionManager()
    motionManager.deviceMotionUpdateInterval = 1.0 / 60
    if motionManager.isDeviceMotionAvailable {
      motionManager.startDeviceMotionUpdates(to: .main, withHandler: { (motion, error) in
        if error == nil {
          self.handleDeviceMotionUpdate(deviceMotion: motion!)
        }
      })
    }
    view.setNeedsUpdateConstraints()
  }
  
  func degrees(radians:Double) -> Double {
    return -180 / .pi * radians
  }
  
  func handleDeviceMotionUpdate(deviceMotion:CMDeviceMotion) {
    
    let roll = degrees(radians: deviceMotion.attitude.roll)
    if roll <= 95 && roll >= 85 && blurEffectView.isHidden && !startView.isHidden {
      startView.isHidden = true
    }
    if roll <= 5.0 && roll >= -5 && blurEffectView.isHidden && startView.isHidden {
      blurEffectView.isHidden = false
      synthesizeSpeech(fromString: "stupid")
    }
    if roll <= 95 && roll >= 85 && !blurEffectView.isHidden && startView.isHidden {
      blurEffectView.isHidden = true
      goToNextWords()
    }
    if roll <= 185 && roll >= 175 && blurEffectView.isHidden && startView.isHidden {
      blurEffectView.isHidden = false
      synthesizeSpeech(fromString: "great")
      greatCount = greatCount + 1
    }
    
  }
  
  func goToNextWords() {
    guard let cardManager = cardManager else { return }
    let page = Int(scrollView.contentOffset.x / scrollView.bounds.size.width)
    if page < cardManager.toDoCount - 1 {
      UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
        self.scrollView.contentOffset.x = self.scrollView.bounds.size.width * CGFloat(page + 1)}, completion: nil)
    } else if page == cardManager.toDoCount - 1 {
      let scoreView = GameView(frame: CGRect(x: UIScreen.main.bounds.width * CGFloat(cardManager.toDoCount), y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), word: "\(greatCount!) 점 / \(cardManager.toDoCount)")
      scoreView.exitBtnDelegate = self
      scrollView.addSubview(scoreView)
      UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
        self.scrollView.contentOffset.x = self.scrollView.bounds.size.width * CGFloat(page + 1)}, completion: nil)
    }
    
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
      
      
      blurEffectView.snp.makeConstraints({ (make) in
        make.edges.equalTo(self.view)
      })
      startView.snp.makeConstraints({ (make) in
        make.edges.equalTo(self.view)
      })
      didSetupConstraints = true
    }
    super.updateViewConstraints()
  }
  
  func inputCardToScrollView() {
    guard let cardManager = cardManager else { return }
    for i in 0..<cardManager.toDoCount {
      let view = GameView(frame: CGRect(x: UIScreen.main.bounds.width * CGFloat(i), y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), word: cardManager.cardAt(index: i).word)
      view.exitBtnDelegate = self
      scrollView.addSubview(view)
    }
  }
  
  
  func synthesizeSpeech(fromString string:String) {
    let speechUtterence = AVSpeechUtterance(string: string)
    speechSynthesizer.speak(speechUtterence)
  }
  
}

extension GameVC: ExitBtnDelegate {
  func exitBtnTapped(sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }
}
