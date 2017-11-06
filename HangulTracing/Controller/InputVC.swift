//
//  InputVC.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 4..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit

class InputVC: UIViewController {
  
  var didSetupConstraints = false
  var cardManager: CardManager?
  var wordTextField: UITextField = {
    let textField = UITextField()
    textField.backgroundColor = #colorLiteral(red: 0.9385011792, green: 0.7164435983, blue: 0.3331357837, alpha: 1)
    textField.textAlignment = .center
    textField.placeholder = "단어를 입력하세요"
    return textField
  }()
  var saveBtn: UIButton = {
    let btn = UIButton()
    btn.setTitle("SAVE", for: .normal)
    btn.backgroundColor = #colorLiteral(red: 0.9994240403, green: 0.3548831371, blue: 0.08110601978, alpha: 1)
    btn.isHidden = true
    return btn
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    view.addSubview(wordTextField)
    view.addSubview(saveBtn)
    saveBtn.addTarget(self, action: #selector(InputVC.saveBtnTapped(_:)), for: .touchUpInside)
    wordTextField.addTarget(self, action: #selector(InputVC.checkTextField(_:)), for: .editingChanged)
    
    let tapForClosingKeyboard = UITapGestureRecognizer(target: self, action: #selector(InputVC.closeKeyboard(_:)))
    view.addGestureRecognizer(tapForClosingKeyboard)
    
    view.setNeedsUpdateConstraints()
  }
  
  override func updateViewConstraints() {
    if !didSetupConstraints {
      
      wordTextField.snp.makeConstraints({ (make) in
        make.top.left.equalTo(self.view).offset(50)
        make.right.equalTo(self.view).offset(-50)
        make.height.equalTo(50)
      })
      
      saveBtn.snp.makeConstraints({ (make) in
        make.top.equalTo(wordTextField.snp.bottom).offset(10)
        make.width.height.equalTo(wordTextField)
        make.centerX.equalTo(self.view)
      })
      
      didSetupConstraints = true
    }
    
    super.updateViewConstraints()
  }
  
  @objc func closeKeyboard(_ recognizer: UITapGestureRecognizer) {
    view.endEditing(true)
  }
  
  @objc func saveBtnTapped(_ sender: UIButton) {
    guard let words = wordTextField.text, wordTextField.text != " " else { return }
    
    let newCard = WordCard(word: words)
    cardManager?.addCard(newCard: newCard)
    dismiss(animated: true, completion: nil)
  }
  
  @objc func checkTextField(_ sender: UITextField) {
    if wordTextField.text == "" {
      saveBtn.isHidden = true
    } else {
      saveBtn.isHidden = false
    }
  }
  
}


