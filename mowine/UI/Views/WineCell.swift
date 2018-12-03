//
//  WineCell.swift
//  mowine
//
//  Created by Josh Freed on 3/14/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import UIKit
import Cosmos

class WineCell: UITableViewCell {
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var wineTypeLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(wine: WineListViewModel) {
        nameLabel.text = wine.name
        wineTypeLabel.text = wine.type
        ratingView.rating = wine.rating
        configure(thumbnail: wine.thumbnail)
    }
    
    func configure(thumbnail: Data?) {
        if let thumbnail = thumbnail, let image = UIImage(data: thumbnail) {
            thumbnailImageView.image = image
        } else {
            thumbnailImageView.image = #imageLiteral(resourceName: "Default Wine Image")
        }
        thumbnailImageView.layer.cornerRadius = thumbnailImageView.frame.size.width / 2
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.contentMode = .scaleAspectFill
    }
}
