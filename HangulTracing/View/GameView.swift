//
//  GameView.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 11..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit

protocol ExitBtnDelegate: class {
  func exitBtnTapped(sender: UIButton)
}

extension ExitBtnDelegate {
  func exitBtnTapped(sender: UIButton) {}
}

class GameView: UIView {
  weak var exitBtnDelegate: ExitBtnDelegate?
  private(set) var words: String
  private(set) var wordLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.font = label.font.withSize(50)
    label.baselineAdjustment = .alignCenters
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.1
    label.textColor = UIColor(hex: "65418F")
    return label
  }()
  private(set) var exitBtn: UIButton = {
    let btn = UIButton()
    return btn
  }()
  
  init(frame: CGRect, word: String) {
    self.words = word
    super.init(frame: frame)
    
    backgroundColor = UIColor(patternImage: UIImage(named: "blackBoard")!)
    setupView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupView() {
    
    wordLabel.text = words
    wordLabel.textAlignment = .center
    wordLabel.font = wordLabel.font.withSize(100)
    wordLabel.adjustsFontSizeToFitWidth = true
    wordLabel.baselineAdjustment = .alignCenters
    wordLabel.minimumScaleFactor = 0.1
    wordLabel.textColor = UIColor.white
    addSubview(wordLabel)
    addSubview(exitBtn)
    exitBtn.setImage(UIImage(named: "delete"), for: .normal)
    exitBtn.addTarget(self, action: #selector(GameView.exitBtnTapped), for: .touchUpInside)
    
    wordLabel.snp.makeConstraints { (make) in
      make.left.top.equalTo(self).offset(10)
      make.bottom.right.equalTo(self).offset(-10)
    }
    exitBtn.snp.makeConstraints({ (make) in
      make.width.height.equalTo(50)
      make.left.top.equalTo(self).offset(2)
    })
  }
  
  func setWords(words: String) {
    wordLabel.text = words
  }
  
  @objc func exitBtnTapped() {
    self.exitBtnDelegate?.exitBtnTapped(sender: exitBtn)
  }
  
}
