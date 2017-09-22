//
//  UIViewController.swift
//  mowine
//
//  Created by Josh Freed on 9/22/17.
//  Copyright © 2017 BleepSmazz. All rights reserved.
//

import UIKit

extension UIViewController {
    func isModal() -> Bool {        
        if let navigationController = self.navigationController {
            if navigationController.viewControllers.first != self{
                return false
            }
        }
        
        if self.presentingViewController != nil {
            return true
        }
        
        if self.navigationController?.presentingViewController?.presentedViewController == self.navigationController  {
            return true
        }
        
        if self.tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        
        return false
    }
}
