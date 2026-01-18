//
//  UIColor.swift
//  mowine
//
//  Created by Josh Freed on 7/1/17.
//  Copyright © 2017 BleepSmazz. All rights reserved.
//

import UIKit
import SwiftUI

extension UIColor {
    class var mwSecondary: UIColor {
        return #colorLiteral(red: 0.7019607843, green: 0.6156862745, blue: 0.8588235294, alpha: 1)
    }
    
    class var mwButtonPrimary: UIColor {
        return #colorLiteral(red: 0.4039215686, green: 0.2274509804, blue: 0.7176470588, alpha: 1)
    }
    
    class var mwButtonSecondary: UIColor {
        return #colorLiteral(red: 0.7019607843, green: 0.6156862745, blue: 0.8588235294, alpha: 1)
    }
    
    class var mwDefaultGradient1: UIColor {
//        return #colorLiteral(red: 0.2928104575, green: 0.2274509804, blue: 0.7176470588, alpha: 1)
        return #colorLiteral(red: 0.4822859745, green: 0.2693989071, blue: 0.85, alpha: 1)
//        return #colorLiteral(red: 0.5106557377, green: 0.2852459017, blue: 0.9, alpha: 1)
    }
    
    class var mwDefaultGradient2: UIColor {
        return #colorLiteral(red: 0.4039215686, green: 0.2274509804, blue: 0.7176470588, alpha: 1)
//        return #colorLiteral(red: 0.5215686274, green: 0.2274509804, blue: 0.7176470588, alpha: 1)
    }
    
    class var google: UIColor {
        return #colorLiteral(red: 0.8588235294, green: 0.1960784314, blue: 0.2117647059, alpha: 1)
    }
}

extension Color {
    static var mwSecondary: Color {
        return Color(UIColor.mwSecondary)
    }
}
