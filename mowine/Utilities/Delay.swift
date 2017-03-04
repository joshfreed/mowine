//
//  Delay.swift
//  mowine
//
//  Created by Josh Freed on 3/4/17.
//  Copyright © 2017 BleepSmazz. All rights reserved.
//

import UIKit

func delay(seconds: Double, action: @escaping () -> ()) {
    let delay = seconds * Double(NSEC_PER_SEC)
    let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: time) {
        action()
    }
}
