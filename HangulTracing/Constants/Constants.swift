//
//  Constants.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 7..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit

struct Constants {
  //notification
  //let NOTI_CARD_SELECTED = Notification.Name(rawValue: "cardSelected")
  let NOTI_DRAW_COMPLETED = Notification.Name("drawCompleted")
  let NOTI_PHOTO_SELECTED = Notification.Name(rawValue: "photoSelected")
  let catImgData = UIImageJPEGRepresentation(UIImage(named: "cat")!, 1)
  let dogImgData = UIImageJPEGRepresentation(UIImage(named: "dog")!, 1)
  let giraffeImgData = UIImageJPEGRepresentation(UIImage(named: "giraffe")!, 1)
  let elephantImgData = UIImageJPEGRepresentation(UIImage(named: "elephant")!, 1)
  let zebraImgData = UIImageJPEGRepresentation(UIImage(named: "zebra")!, 1)
  let duckImgData = UIImageJPEGRepresentation(UIImage(named: "duck")!, 1)
}
