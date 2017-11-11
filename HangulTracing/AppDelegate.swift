//
//  AppDelegate.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 3..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit
import SnapKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    window = UIWindow(frame: UIScreen.main.bounds)
    let cardListVC = CardListVC()
    window?.rootViewController = UINavigationController(rootViewController: cardListVC)
    window?.makeKeyAndVisible()
    
    return true
  }
  
  func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
    let presentedViewController = UIHelper.topViewController()
    if presentedViewController is orientationIsOnlyLandScapeRight {
      return .landscapeRight
    }
    return .portrait
  }

}

protocol orientationIsOnlyLandScapeRight {}
class UIHelper {
  
  class func topViewController() -> UIViewController?
  {
    let helper = UIHelper()
    return helper.topViewControllerWithRootViewController(rootViewController: UIApplication.shared.keyWindow?.rootViewController)
  }
  
  private func topViewControllerWithRootViewController(rootViewController:UIViewController?) -> UIViewController?
  {
    if(rootViewController != nil)
    {
      // UITabBarController
      if let tabBarController = rootViewController as? UITabBarController,
        let selectedViewController = tabBarController.selectedViewController {
        return self.topViewControllerWithRootViewController(rootViewController: selectedViewController)
      }
      
      // UINavigationController
      if let navigationController = rootViewController as? UINavigationController ,let visibleViewController = navigationController.visibleViewController {
        return self.topViewControllerWithRootViewController(rootViewController: visibleViewController)
      }
      
      if ((rootViewController!.presentedViewController) != nil) {
        let presentedViewController = rootViewController!.presentedViewController;
        return self.topViewControllerWithRootViewController(rootViewController: presentedViewController!);
      }else
      {
        return rootViewController
      }
    }
    
    return nil
  }
  
}


