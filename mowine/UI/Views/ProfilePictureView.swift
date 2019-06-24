//
//  ProfilePictureView.swift
//  mowine
//
//  Created by Josh Freed on 6/16/19.
//  Copyright © 2019 Josh Freed. All rights reserved.
//

import UIKit
import JFLib

class ProfilePictureView: NibBasedView {
    @IBOutlet weak var imageView: UIImageView!
    
    weak var delegate: ProfilePictureViewDelegate?
    
    override func setupView() {        
        setNeedsLayout()
        layoutIfNeeded()
        
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedView)))
    }
    
    @objc func tappedView() {
        delegate?.tappedProfilePicture(self)
    }
    
    func setImage(_ image: UIImage) {
        imageView.image = image
    }
    
    func setData(_ data: Data?) {
        if let data = data {
            imageView.image = UIImage(data: data)
        } else {
            imageView.image = UIImage(named: "No Profile Picture")
        }
    }
}

protocol ProfilePictureViewDelegate: class {
    func tappedProfilePicture(_ view: ProfilePictureView)
}
