//
//  Viewcontroller+Ext.swift
//  Tourist
//
//  Created by Hận Lê on 11/23/18.
//  Copyright © 2018 TVT25. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Methods
public extension UIViewController {
    
    
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    public class func getTopViewController(from window: UIWindow? = UIApplication.shared.keyWindow) -> UIViewController? {
        return getTopViewController(from: window?.rootViewController)
    }
    
    public func getTopViewController_(from window: UIWindow? = UIApplication.shared.keyWindow) -> UIViewController? {
        return UIViewController.getTopViewController(from: window?.rootViewController)
    }
    
    
    
    class func getTopViewController(from rootVC: UIViewController?) -> UIViewController? {
        if let nav = rootVC as? UINavigationController, let navFirst = nav.visibleViewController {
            return getTopViewController(from: navFirst)
        } else if let tab = rootVC as? UITabBarController, let selectedTab = tab.selectedViewController {
            return getTopViewController(from: selectedTab)
        } else if let split = rootVC as? UISplitViewController, let splitLast = split.viewControllers.last {
            return getTopViewController(from: splitLast)
        } else if let presented = rootVC?.presentedViewController {
            return getTopViewController(from: presented)
        }
        
        return rootVC
    }
}

extension UINavigationController {
    func popToRootViewController(animated:Bool = true, completion: @escaping ()->()) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.popToRootViewController(animated: animated)
        CATransaction.commit()
    }
}
