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
    let gradient: CAGradientLayer = CAGradientLayer()
    
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
        layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradient.frame = self.bounds
    }
    
    func applyGradient() {
        applyGradient(colours: [.mwDefaultGradient1, .mwDefaultGradient2])
    }
    
    func applyGradient(colours: [UIColor]) -> Void {
        applyGradient(colours, locations: [0, 1])
    }
    
    func applyGradient(_ colours: [UIColor], locations: [NSNumber]?) -> Void {
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        layer.addSublayer(gradient)
    }
}
