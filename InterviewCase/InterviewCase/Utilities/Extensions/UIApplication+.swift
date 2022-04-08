//
//  UIApplication+.swift
//  InterviewCase
//
//  Created by Maviye Çökelez on 8.04.2022.
//

import Foundation
import UIKit

extension UIApplication {
  class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
    if let tabController = controller as? UITabBarController {
      return topViewController(controller: tabController.selectedViewController)
    }
    if let navController = controller as? UINavigationController {
      return topViewController(controller: navController.visibleViewController)
    }
    if let presented = controller?.presentedViewController {
      return topViewController(controller: presented)
    }
    return controller
  }
}
