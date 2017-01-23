//
//  UIImageView.swift
//  mowine
//
//  Created by Josh Freed on 1/7/17.
//  Copyright © 2017 BleepSmazz. All rights reserved.
//

import UIKit

extension UIImageView {
    func fixTintIssue() {
        let temp = image
        image = nil
        image = temp
    }
}

