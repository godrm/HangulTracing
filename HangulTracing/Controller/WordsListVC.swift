//
//  WordsListVC.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 3..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit
import RealmSwift

class WordsListVC: UIViewController {
  
  var didSetupConstraints = false
  
  var tableView: UITableView = {
    let tabelView = UITableView()
    return tabelView
  }()
  var dataProvider: CardListDataProvider = {
    let provider = CardListDataProvider()
    return provider
  }()
  var addBarBtnItem: UIBarButtonItem = {
    //이 시점에서는 target 과 action에 값을 넣어도 설정되지 않는군...
    let buttonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(WordsListVC.addBtnTapped(_:)))
    return buttonItem
  }()
  let cardManager = CardManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    NotificationCenter.default.addObserver(self, selector: #selector(WordsListVC.pushTracingVC(_:)), name: Constants().NOTI_CARD_SELECTED, object: nil)
    view.addSubview(tableView)
    tableView.register(CardCell.self, forCellReuseIdentifier: "CardCell")
    tableView.dataSource = dataProvider
    tableView.delegate = dataProvider
    dataProvider.cardManager = cardManager
    addBarBtnItem.target = self
    addBarBtnItem.action = #selector(WordsListVC.addBtnTapped(_:))
    navigationItem.rightBarButtonItem = addBarBtnItem
    
    view.setNeedsUpdateConstraints()
  }
  
  override func updateViewConstraints() {
    if !didSetupConstraints {
      
      tableView.snp.makeConstraints { make in
        make.edges.equalTo(self.view)
      }
      
      didSetupConstraints = true
    }
    super.updateViewConstraints()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
  }
  
  @objc func addBtnTapped(_ sender: UIBarButtonItem) {
    let alertController = UIAlertController(title: "New Word", message: "단어를 입력하세요", preferredStyle: .alert)
    var alertTextField: UITextField!
    alertController.addTextField { textField in
      alertTextField = textField
      textField.placeholder = "단어를 입력하세요"
    }
    alertController.addAction(UIAlertAction(title: "ADD", style: .default) { _ in
      guard let text = alertTextField.text , !text.isEmpty else { return }
      
      self.dataProvider.cardManager?.addCard(newCard: WordCard(word: text))
      self.tableView.reloadData()
    })
    alertController.addAction(UIAlertAction(title: "CANCEL", style: .cancel) { _ in
    })
    
    present(alertController, animated: true, completion: nil)
  }
  
  @objc func pushTracingVC(_ notification: NSNotification) {
    guard let index = notification.userInfo!["index"] as? Int else { fatalError() }
    let nextVC = TracingVC()
    nextVC.cardInfo = (cardManager, index)
    navigationController?.pushViewController(nextVC, animated: true)
  }
}
