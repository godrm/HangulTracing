//
//  WordCardCell.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 8..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit

protocol DeleteBtnDelegate: class {
  func deleteBtnTapped(sender: UIButton)
}

extension DeleteBtnDelegate {
  func deleteBtnTapped(sender: UIButton) {}
}

class WordCardCell: UICollectionViewCell {
  
  weak var deleteBtnDelegate: DeleteBtnDelegate?
  
  var imgView: UIImageView = {
    let imgView = UIImageView()
    imgView.contentMode = .scaleAspectFill
    return imgView
  }()
  var deleteBtn: UIButton = {
    let btn = UIButton()
    btn.setImage(UIImage(named: "delete"), for: .normal)
    return btn
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
    contentView.addSubview(deleteBtn)
    deleteBtn.isHidden = true
    
    let longPress = UILongPressGestureRecognizer(target: self, action: #selector(WordCardCell.handleLongPress(_:)))
    longPress.minimumPressDuration = 0.5
    longPress.delaysTouchesBegan = true
    self.addGestureRecognizer(longPress)
    deleteBtn.addTarget(self, action: #selector(deleteBtnTapped), for: .touchUpInside)
    
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
    deleteBtn.snp.makeConstraints { (make) in
      make.left.top.equalTo(contentView).offset(2)
      make.width.height.equalTo(50)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configCell(card: WordCard, cellMode: CellMode) {
    
    if cellMode == .normal {
      deleteBtn.isHidden = true
    } else {
      deleteBtn.isHidden = false
    }
    wordLabel.text = card.word
    wordLabel.font = UIFont(name: "NanumBarunpen", size: 14)!
    imgView.image = UIImage(data: card.imgData)
  }
  
  @objc func deleteBtnTapped() {
    self.deleteBtnDelegate?.deleteBtnTapped(sender: deleteBtn)
  }
  
  @objc func handleLongPress(_ recognizer: UILongPressGestureRecognizer) {
    if recognizer.state != UIGestureRecognizerState.ended {
      return
    }
    NotificationCenter.default.post(name: Constants().NOTI_CELL_LONGPRESSED, object: nil)
  }
}

