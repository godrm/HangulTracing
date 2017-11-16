//
//  PlayerVC.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 16..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit
import AVKit

class PlayerVC: AVPlayerViewController, orientationIsOnlyLandScapeRight {

  override func viewDidLoad() {
    super.viewDidLoad()
    view.layer.cornerRadius = 15
    view.clipsToBounds = true
  }
  
  
//  override func viewDidLayoutSubviews() {
//    super.viewDidLayoutSubviews()
//
//    self.view.snp.makeConstraints { make in
//      make.width.equalTo(UIScreen.main.bounds.width * 3 / 5)
//      make.height.equalTo(UIScreen.main.bounds.height * 3 / 5)
//      make.centerX.equalTo(UIScreen.main.bounds.width/2)
//      make.centerY.equalTo(UIScreen.main.bounds.height/2)
//    }
//  }
}
