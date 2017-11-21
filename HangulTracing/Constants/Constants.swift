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
 
  let NOTI_DRAW_COMPLETED = Notification.Name("drawCompleted")
  let NOTI_PHOTO_SELECTED = Notification.Name(rawValue: "photoSelected")
  let catImgData = UIImageJPEGRepresentation((UIImage(named: "cat")?.downSizeImageWith(downRatio: 0.5))!, 1)
  let dogImgData = UIImageJPEGRepresentation((UIImage(named: "dog")?.downSizeImageWith(downRatio: 0.5))!, 1)
  let giraffeImgData = UIImageJPEGRepresentation((UIImage(named: "giraffe")?.downSizeImageWith(downRatio: 0.5))!, 1)
  let elephantImgData = UIImageJPEGRepresentation((UIImage(named: "elephant")?.downSizeImageWith(downRatio: 0.5))!, 1)
  let zebraImgData = UIImageJPEGRepresentation((UIImage(named: "zebra")?.downSizeImageWith(downRatio: 0.5))!, 1)
  let duckImgData = UIImageJPEGRepresentation((UIImage(named: "duck")?.downSizeImageWith(downRatio: 0.5))!, 1)
  let bagImgData = UIImageJPEGRepresentation((UIImage(named: "bag")?.downSizeImageWith(downRatio: 0.5))!, 1)
  let chairImgData = UIImageJPEGRepresentation((UIImage(named: "chair")?.downSizeImageWith(downRatio: 0.5))!, 1)
  let kimbobImgData = UIImageJPEGRepresentation((UIImage(named: "kimbob")?.downSizeImageWith(downRatio: 0.5))!, 1)
  let kimchiImgData = UIImageJPEGRepresentation((UIImage(named: "kimchi")?.downSizeImageWith(downRatio: 0.5))!, 1)
  let pencilImgData = UIImageJPEGRepresentation((UIImage(named: "pencil")?.downSizeImageWith(downRatio: 0.5))!, 1)
  let pizzaImgData = UIImageJPEGRepresentation((UIImage(named: "pizza")?.downSizeImageWith(downRatio: 0.5))!, 1)
  let ttokppokkiImgData = UIImageJPEGRepresentation((UIImage(named: "ttokppokki")?.downSizeImageWith(downRatio: 0.5))!, 1)
  let socksImgData = UIImageJPEGRepresentation((UIImage(named: "socks")?.downSizeImageWith(downRatio: 0.5))!, 1)
  let chickenImgData = UIImageJPEGRepresentation((UIImage(named: "chicken")?.downSizeImageWith(downRatio: 0.5))!, 1)
  let gimImgData = UIImageJPEGRepresentation((UIImage(named: "gim")?.downSizeImageWith(downRatio: 0.5))!, 1)
  let lionImgData = UIImageJPEGRepresentation((UIImage(named: "lion")?.downSizeImageWith(downRatio: 0.5))!, 1)
  let ramienImgData = UIImageJPEGRepresentation((UIImage(named: "ramien")?.downSizeImageWith(downRatio: 0.5))!, 1)
  let tigerImgData = UIImageJPEGRepresentation((UIImage(named: "tiger")?.downSizeImageWith(downRatio: 0.5))!, 1)
  let pepperImgData = UIImageJPEGRepresentation((UIImage(named: "pepper")?.downSizeImageWith(downRatio: 0.5))!, 1)
  let airplaneImgData = UIImageJPEGRepresentation((UIImage(named: "airplane")?.downSizeImageWith(downRatio: 0.5))!, 1)
  let busImgData = UIImageJPEGRepresentation((UIImage(named: "bus")?.downSizeImageWith(downRatio: 0.5))!, 1)
  let hatImgData = UIImageJPEGRepresentation((UIImage(named: "hat")?.downSizeImageWith(downRatio: 0.5))!, 1)
  let gloveImgData = UIImageJPEGRepresentation((UIImage(named: "glove")?.downSizeImageWith(downRatio: 0.5))!, 1)
}
