//
//  UISearchBar+setSearchFieldColor.swift
//  mowine
//
//  Created by Josh Freed on 4/3/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import UIKit

extension UISearchBar {
    public func setSearchFieldColor(_ color: UIColor) {
        if #available(iOS 13.0, *) {
            searchTextField.backgroundColor = color
        } else {
            if
                let textfield = self.value(forKey: "searchField") as? UITextField,
                let backgroundview = textfield.subviews.first
            {
                textfield.tintColor = .darkGray
                backgroundview.backgroundColor = color
                backgroundview.layer.cornerRadius = 10
                backgroundview.clipsToBounds = true
            }
        }
    }
}
