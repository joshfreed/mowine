//
//  MWButton.swift
//  mowine
//
//  Created by Josh Freed on 3/20/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import UIKit

@IBDesignable
class MWButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func prepareForInterfaceBuilder() {
        setup()
    }
    
    private func setup() {
        layer.cornerRadius = 5
    }
}
