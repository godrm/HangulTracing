//
//  GameView.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 11..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit

class GameView: UIView {
  var words: String
  var wordLabel: UILabel = {
    let label = UILabel()
    return label
  }()
  
  init(frame: CGRect, word: String) {
    self.words = word
    super.init(frame: frame)
    
    self.backgroundColor = UIColor(hex: "1EC545")
    setupView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupView() {
    
    wordLabel.text = words
    wordLabel.textAlignment = .center
    wordLabel.font = wordLabel.font.withSize(100)
    wordLabel.textColor = UIColor.white
    addSubview(wordLabel)
    
    wordLabel.snp.makeConstraints { (make) in
      make.left.top.equalTo(self).offset(50)
      make.bottom.right.equalTo(self).offset(-50)
    }
  }
  
}
