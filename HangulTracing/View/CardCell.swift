//
//  CardCell.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 3..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit

class CardCell: UITableViewCell {
  
  var wordLabel: UILabel = {
    let label = UILabel()
    label.backgroundColor = #colorLiteral(red: 0.9385011792, green: 0.7164435983, blue: 0.3331357837, alpha: 1)
    return label
  }()
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    contentView.addSubview(wordLabel)
    
    wordLabel.snp.makeConstraints { (make) in
      make.left.equalTo(contentView).offset(20)
      make.right.equalTo(contentView).offset(-20)
      make.top.equalTo(contentView).offset(2)
      make.bottom.equalTo(contentView).offset(-2)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configCell(card: WordCard) {
    wordLabel.text = card.word
    
  }
  
}
