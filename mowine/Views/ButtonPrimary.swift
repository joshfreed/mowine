//
//  ButtonPrimary.swift
//  mowine
//
//  Created by Josh Freed on 7/1/17.
//  Copyright © 2017 BleepSmazz. All rights reserved.
//

import UIKit

@IBDesignable
class ButtonPrimary: UIButton {
    let defaultFontSize: CGFloat = 37
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func prepareForInterfaceBuilder() {
        setup()
    }

    private func setup() {
        backgroundColor = .mwButtonPrimary
        tintColor = .white
        layer.cornerRadius = 5
        let fontSize = titleLabel?.font.pointSize ?? defaultFontSize
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.light)
    }
}
