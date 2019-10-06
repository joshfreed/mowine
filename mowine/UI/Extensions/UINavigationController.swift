//
//  UINavigationController.swift
//  mowine
//
//  Created by Josh Freed on 12/29/17.
//  Copyright © 2017 BleepSmazz. All rights reserved.
//

import UIKit

extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func hideNavigationBar() {
        navigationBar.isTranslucent = false
        navigationBar.shadowImage = UIImage()
    }
    
    func showNavigationBar() {
        navigationBar.isTranslucent = true
        navigationBar.shadowImage = nil
    }
}

class DefaultContentNavigationController: UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
}

extension UINavigationController {
    func mwPrimaryAppearance() {
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance.mwPrimaryAppearance()
            navigationBar.standardAppearance = appearance
            navigationBar.compactAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
        } else {
            // Fallback on earlier versions
        }
        
        navigationBar.tintColor = UIColor.mwButtonSecondary
    }
}
