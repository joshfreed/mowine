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
    var activityIndicator: UIActivityIndicatorView!
    private var previousTitle: String?
    
    var isLoading: Bool {
        return activityIndicator.isAnimating
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func prepareForInterfaceBuilder() {
        setup()
    }

    private func setup() {
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.isHidden = true
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        backgroundColor = .mwButtonPrimary
        tintColor = .white
        layer.cornerRadius = 5
        let fontSize = titleLabel?.font.pointSize ?? defaultFontSize
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.light)
        
        var hue: CGFloat = 0
        var sat: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        UIColor.mwButtonSecondary.getHue(&hue, saturation: &sat, brightness: &brightness, alpha: &alpha)
        print("Hue: \(hue), \(sat), \(brightness), \(alpha)")
    }
    
    func useDefaultFontSize() {
        titleLabel?.font = UIFont.systemFont(ofSize: defaultFontSize, weight: UIFont.Weight.light)
    }
    
    func useFont(ofSize size: CGFloat, weight: UIFont.Weight) {
        titleLabel?.font = UIFont.systemFont(ofSize: size, weight: weight)
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
