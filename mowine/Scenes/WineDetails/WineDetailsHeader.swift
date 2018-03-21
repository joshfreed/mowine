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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fromNib()   // 5.
    }
    
    init() {
        super.init(frame: CGRect.zero)
        fromNib()
    }
    
    func configure(wine: WineDetails.WineViewModel) {
        nameLabel.text = wine.name
        
        ratingView.rating = wine.rating
        ratingView.settings.totalStars = Int(wine.rating)
    }
}
