//
//  UISearchBar.swift
//  mowine
//
//  Created by Josh Freed on 4/4/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import UIKit

extension UISearchBar {
    func changeBarColor(_ color: UIColor) {
        for view in subviews {
            for subview in view.subviews {
                if let textField = subview as? UITextField {
                    textField.backgroundColor = color
                }
            }
        }
    }
    
    public func setTextColor(_ color: UIColor) {
        let svs = subviews.flatMap { $0.subviews }
        guard let tf = (svs.filter { $0 is UITextField }).first as? UITextField else { return }
        tf.textColor = color
    }
}
