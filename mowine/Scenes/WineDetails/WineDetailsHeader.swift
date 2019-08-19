//
//  WineDetailsHeader.swift
//  mowine
//
//  Created by Josh Freed on 3/21/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import UIKit
import Cosmos
import JFLib

@IBDesignable
class WineDetailsHeader: NibDesignable {
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    
    func configure(wine: WineDetails.WineViewModel) {
        nameLabel.text = wine.name        
        ratingView.rating = wine.rating
        ratingView.settings.totalStars = Int(wine.rating)
    }
    
    func setWineImage(_ image: UIImage?) {
        pictureImageView.image = image
        pictureImageView.clipsToBounds = true
        pictureImageView.contentMode = .scaleAspectFill
        pictureImageView.layer.cornerRadius = pictureImageView.frame.size.width / 2
    }
}
