//
//  UIApplicationExtensions.swift
//  V1BaseApp
//
//  Created by ThaiNguyen on 23/12/25.
//

import Foundation

public extension UIApplication {

    func topViewController(
        base: UIViewController? = {
            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

            if var topController = keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }

            // topController should now be your topmost view controller
            return topController
            }
            return nil
        }()
    ) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }

        if let tab = base as? UITabBarController {
            return topViewController(base: tab.selectedViewController)
        }

        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }

        return base
    }
}
