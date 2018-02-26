//
//  MenuItem.swift
//  mowine
//
//  Created by Josh Freed on 2/23/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import UIKit
import JFLib

protocol MenuItemDelegate: class {
    func didSelect(menuItem: MenuItem)
}

@IBDesignable
class MenuItem: NibDesignable {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBInspectable
    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    @IBInspectable
    var icon: UIImage = UIImage() {
        didSet {
            imageView.image = icon
        }
    }
    
    weak var delegate: MenuItemDelegate?
    
    // MARK: - Initializer
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    // MARK: - NSCoding
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedMenuItem)))
    }
    
    @objc func tappedMenuItem() {
        delegate?.didSelect(menuItem: self)
    }
}
