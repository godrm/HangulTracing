//
//  WordsListVC.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 3..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit

class WordsListVC: UIViewController {
  
  var didSetupConstraints = false
  
  var tableView: UITableView = {
    let tabelView = UITableView()
    return tabelView
  }()
  let cardManager = CardManager()
  var dataProvider: CardListDataProvider = {
    let provider = CardListDataProvider()
    return provider
  }()
  var addBarBtnItem: UIBarButtonItem = {
    //이 시점에서는 target 과 action에 값을 넣어도 설정되지 않는군...
    let buttonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(WordsListVC.addBtnTapped(_:)))
    return buttonItem
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(tableView)
    tableView.register(CardCell.self, forCellReuseIdentifier: "CardCell")
    tableView.dataSource = dataProvider
    tableView.delegate = dataProvider
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
  
  @objc func addBtnTapped(_ sender: UIBarButtonItem) {
    let inputVC = InputVC()
    present(inputVC, animated: true, completion: nil)
  }
}
