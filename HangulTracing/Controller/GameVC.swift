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
  var timerLabel: UILabel = {
    let label = UILabel()
    label.layer.cornerRadius = 15
    label.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    label.textAlignment = .center
    return label
  }()
  var timer: Timer!
  var seconds = 60
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
    timer = Timer()
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
    synthesizeSpeech(fromString: "핸드폰 들어")
    view.addSubview(timerLabel)
    
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
      startTimer()
    }
    if roll <= 5.0 && roll >= -5 && blurEffectView.isHidden && startView.isHidden {
      blurEffectView.isHidden = false
      synthesizeSpeech(fromString: "통과")
    }
    if roll <= 95 && roll >= 85 && !blurEffectView.isHidden && startView.isHidden {
      blurEffectView.isHidden = true
      goToNextWords()
    }
    if roll <= 185 && roll >= 175 && blurEffectView.isHidden && startView.isHidden {
      blurEffectView.isHidden = false
      synthesizeSpeech(fromString: "정답")
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
      timer.invalidate()
      let scoreView = GameView(frame: CGRect(x: UIScreen.main.bounds.width * CGFloat(cardManager.toDoCount), y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), word: "\(greatCount!) 점 / \(cardManager.toDoCount)")
      scoreView.exitBtnDelegate = self
      scrollView.addSubview(scoreView)
      synthesizeSpeech(fromString: "\(cardManager.toDoCount)개 중에 \(greatCount!)개 맞았습니다")
      UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
        self.scrollView.contentOffset.x = self.scrollView.bounds.size.width * CGFloat(page + 1)}, completion: nil)
      motionManager.stopDeviceMotionUpdates()
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
      timerLabel.snp.makeConstraints({ (make) in
        make.top.equalTo(self.view).offset(25)
        make.right.equalTo(self.view).offset(-25)
        make.width.height.equalTo(50)
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
  
  func startTimer() {
    timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameVC.updateTimer), userInfo: nil, repeats: true)
  }
  
  @objc func updateTimer() {
    seconds -= 1
    timerLabel.text = "\(seconds)"
    if seconds <= 3 && seconds > 0 {
      synthesizeSpeech(fromString: "\(seconds)초")
    }
    if seconds == 0 {
      timer.invalidate()
      motionManager.stopDeviceMotionUpdates()
      guard let cardManager = cardManager else { return }
      let scoreView = GameView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), word: "\(greatCount!) 점 / \(cardManager.toDoCount)")
      scoreView.exitBtnDelegate = self
      self.view.addSubview(scoreView)
      synthesizeSpeech(fromString: "\(cardManager.toDoCount)개 중에 \(greatCount!)개 맞았습니다")
    }
  }
}

extension GameVC: ExitBtnDelegate {
  func exitBtnTapped(sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }
}
