//
//  WordCardCell.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 8..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit

class WordCardCell: UICollectionViewCell {
  
  var imgView: UIImageView = {
    let imgView = UIImageView()
    return imgView
  }()
  var wordLabel: UILabel = {
    let label = UILabel()
    label.backgroundColor = #colorLiteral(red: 0.9385011792, green: 0.7164435983, blue: 0.3331357837, alpha: 0.8)
    label.font = UIFont(name: "NanumBarunpen", size: 22)!
    label.textAlignment = .center
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    contentView.layer.cornerRadius = 15
    contentView.layer.masksToBounds = true
    contentView.addSubview(imgView)
    contentView.addSubview(wordLabel)
    
    wordLabel.snp.makeConstraints { (make) in
      make.left.equalTo(contentView).offset(2)
      make.right.bottom.equalTo(contentView).offset(-2)
      make.height.equalTo(50)
    }

    imgView.snp.makeConstraints { (make) in
      make.left.top.equalTo(contentView).offset(2)
      make.right.equalTo(contentView).offset(-2)
      make.bottom.equalTo(wordLabel.snp.top).offset(-2)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configCell(card: WordCard) {
    wordLabel.text = card.word
    wordLabel.font = UIFont(name: "NanumBarunpen", size: 14)!
    imgView.image = UIImage(data: card.imgData)
  }
}
