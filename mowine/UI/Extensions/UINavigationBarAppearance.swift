//
//  UINavigationBarAppearance.swift
//  mowine
//
//  Created by Josh Freed on 10/6/19.
//  Copyright © 2019 Josh Freed. All rights reserved.
//

import UIKit

extension UINavigationBarAppearance {
    static func mwPrimaryAppearance() -> UINavigationBarAppearance {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .mwButtonPrimary                
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        return appearance
    }
}
