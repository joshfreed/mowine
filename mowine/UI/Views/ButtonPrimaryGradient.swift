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
    var activityIndicator: UIActivityIndicatorView!
    private var previousTitle: String?
    
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
        setupActivityIndicator()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradient.frame = self.bounds
    }
    
    private func applyGradient() {
        applyGradient(colours: [.mwDefaultGradient1, .mwDefaultGradient2])
    }
    
    private func applyGradient(colours: [UIColor]) -> Void {
        applyGradient(colours, locations: [0, 1])
    }
    
    private func applyGradient(_ colours: [UIColor], locations: [NSNumber]?) -> Void {
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        layer.addSublayer(gradient)
    }

    // MARK: Loading

    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.hidesWhenStopped = true
        activityIndicator.isHidden = true
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }

    func displayLoading() {
        activityIndicator.startAnimating()
        previousTitle = title(for: .normal)
        setTitle(nil, for: .normal)
        isEnabled = false
    }

    func displayNotLoading() {
        activityIndicator.stopAnimating()
        setTitle(previousTitle, for: .normal)
        isEnabled = true
    }
}
