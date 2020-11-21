//
//  Utilities.swift
//  mowineTests
//
//  Created by Josh Freed on 11/21/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import UIKit

public func delay(seconds: Double, action: @escaping () -> ()) {
    let delay = seconds * Double(NSEC_PER_SEC)
    let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: time) {
        action()
    }
}

