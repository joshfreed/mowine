//
//  UINavigationController.swift
//  mowine
//
//  Created by Josh Freed on 12/29/17.
//  Copyright © 2017 BleepSmazz. All rights reserved.
//

import UIKit

extension UINavigationController {
    func hideNavigationBar() {
        navigationBar.isTranslucent = false
        navigationBar.shadowImage = UIImage()
    }
    
    func showNavigationBar() {
        navigationBar.isTranslucent = true
        navigationBar.shadowImage = nil
    }
}
