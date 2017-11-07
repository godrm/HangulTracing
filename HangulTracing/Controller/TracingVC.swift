//
//  TracingVC.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 7..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit

class TracingVC: UIViewController {
  var didSetupConstraints = false
  var itemInfo: (CardManager, Int)?
  var numberOfCharacters: Int?
  var scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.showsVerticalScrollIndicator = false
    scrollView.isPagingEnabled = true
    scrollView.bounces = false
    return scrollView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    guard let itemInfo = itemInfo else { fatalError() }
    guard let word = itemInfo.0.cardAt(index: itemInfo.1).word as? String else { fatalError() }
    numberOfCharacters = word.count
    
    view.addSubview(scrollView)
    for i in 0..<numberOfCharacters! {
      let view = UIView()
      view.backgroundColor = UIColor.gray
      
      scrollView.addSubview(view)
    }
    view.setNeedsUpdateConstraints()
  }
  
  override func updateViewConstraints() {
    if !didSetupConstraints {
      
      scrollView.snp.makeConstraints({ (make) in
        make.edges.equalTo(self.view)
      })
      for i in 0..<scrollView.subviews.count {
        scrollView.subviews[i].frame = CGRect(x: UIScreen.main.bounds.width * CGFloat(i), y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
      }
      
      scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * CGFloat(numberOfCharacters!), height: UIScreen.main.bounds.height)
      
      didSetupConstraints = true
    }
    super.updateViewConstraints()
  }
}
