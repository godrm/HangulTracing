//
//  InputVC.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 8..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit

class InputVC: UIViewController {
  
  var didSetupConstraints = false
  var cardManager: CardManager?
  var wordTextField: UITextField = {
    let textField = UITextField()
    textField.borderStyle = .bezel
    return textField
  }()
  var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "emptyImage")
    return imageView
  }()
  var cameraBtn: UIButton = {
    let btn = UIButton()
    btn.setImage(UIImage(named: "camera"), for: .normal)
    return btn
  }()
  var addBtn: UIButton = {
    let btn = UIButton()
    btn.backgroundColor = #colorLiteral(red: 0.09182383865, green: 0.6374981999, blue: 0.09660141915, alpha: 1)
    btn.setTitle("ADD", for: .normal)
    btn.layer.cornerRadius = 15
    return btn
  }()
  var cancelBtn: UIButton = {
    let btn = UIButton()
    btn.backgroundColor = #colorLiteral(red: 0.9385011792, green: 0.7164435983, blue: 0.3331357837, alpha: 0.8)
    btn.setTitle("CANCEL", for: .normal)
    btn.layer.cornerRadius = 15
    return btn
  }()
  var capturedPhotoData: Data?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    NotificationCenter.default.addObserver(self, selector: #selector(InputVC.photoCaptured(_:)), name: Constants().NOTI_PHOTO_SELECTED, object: nil)
    view.addSubview(wordTextField)
    view.addSubview(imageView)
    view.addSubview(cameraBtn)
    view.addSubview(addBtn)
    view.addSubview(cancelBtn)
    
    wordTextField.textAlignment = .center
    wordTextField.font = UIFont(name: "NanumBarunpen", size: 14)!
    wordTextField.placeholder = "공백없이 단어를 입력하세요"
    cameraBtn.addTarget(self, action: #selector(InputVC.cameraBtnTapped(_:)), for: .touchUpInside)
    addBtn.addTarget(self, action: #selector(InputVC.addBtnTapped(_:)), for: .touchUpInside)
    cancelBtn.addTarget(self, action: #selector(InputVC.cancelBtnTapped(_:)), for: .touchUpInside)
    view.setNeedsUpdateConstraints()
    
  }
  
  override func updateViewConstraints() {
    if !didSetupConstraints {
      
      wordTextField.snp.makeConstraints({ (make) in
        make.top.equalTo(self.view).offset(100)
        make.left.equalTo(self.view).offset(20)
        make.right.equalTo(self.view).offset(-20)
        make.height.equalTo(50)
      })
      
      imageView.snp.makeConstraints({ (make) in
        make.top.equalTo(wordTextField.snp.bottom).offset(30)
        make.left.equalTo(self.view).offset(100)
        make.height.equalTo(128)
        make.width.equalTo(75)
      })
      
      cameraBtn.snp.makeConstraints({ (make) in
        make.centerY.equalTo(imageView)
        make.left.equalTo(imageView.snp.right).offset(30)
        make.height.width.equalTo(50)
      })
      
      addBtn.snp.makeConstraints({ (make) in
        make.top.equalTo(imageView.snp.bottom).offset(30)
        make.right.equalTo(self.view).offset(-20)
        make.height.equalTo(50)
        make.width.equalTo(160)
      })
      cancelBtn.snp.makeConstraints({ (make) in
        make.top.equalTo(imageView.snp.bottom).offset(30)
        make.left.equalTo(self.view).offset(20)
        make.height.equalTo(50)
        make.width.equalTo(addBtn)
      })
      didSetupConstraints = true
    }
    super.updateViewConstraints()
  }
  
  @objc func cameraBtnTapped(_ sender: UIButton) {
    let cameraVC = CameraVC()
    present(cameraVC, animated: true, completion: nil)
  }
  
  @objc func addBtnTapped(_ sender: UIButton) {
    guard let text = wordTextField.text , !text.components(separatedBy: " ").joined(separator: "").isEmpty else { return }
    let filterdText = text.components(separatedBy: " ").joined(separator: "")
    guard let photoData = capturedPhotoData else { return }
    cardManager?.addCard(newCard: WordCard(word: filterdText, imageData: photoData))
    dismiss(animated: true, completion: nil)
  }
  
  @objc func cancelBtnTapped(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }
  
  @objc func photoCaptured(_ notification: NSNotification) {
    guard let photoData = notification.userInfo!["photoData"] as? Data else { fatalError() }
    capturedPhotoData = photoData
    self.imageView.image = UIImage(data: photoData)
  }
}
