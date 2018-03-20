//
//  ButtonPrimaryGradient.swift
//  mowine
//
//  Created by Josh Freed on 3/19/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import UIKit

@IBDesignable
class ButtonPrimaryGradient: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func prepareForInterfaceBuilder() {
        setup()
    }
    
    private func setup() {
        applyGradient()
        tintColor = .white
        layer.cornerRadius = 5
    }
    
    func applyGradient() {
        applyGradient(colours: [.mwDefaultGradient1, .mwDefaultGradient2])
    }
    
    func applyGradient(colours: [UIColor]) -> Void {
        applyGradient(colours, locations: [0, 1])
    }
    
    func applyGradient(_ colours: [UIColor], locations: [NSNumber]?) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        gradient.cornerRadius = 5
        gradient.masksToBounds = true
        layer.insertSublayer(gradient, at: 0)
    }
}
