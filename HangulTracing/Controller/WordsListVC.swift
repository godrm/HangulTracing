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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(tableView)
    
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
}
