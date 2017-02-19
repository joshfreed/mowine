//
//  WineTableViewCell.swift
//  mowine
//
//  Created by Josh Freed on 2/6/17.
//  Copyright © 2017 BleepSmazz. All rights reserved.
//

import UIKit
import Cosmos

class WineTableViewCell: UITableViewCell {
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var varietyLabel: UILabel!
    @IBOutlet weak var cosmosView: CosmosView!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(wine: MyWines.FetchMyWines.ViewModel.WineViewModel) {
        thumbnailImageView.image = wine.thumbnail
        nameLabel.text = wine.name
        varietyLabel.text = wine.variety
        cosmosView.rating = wine.rating
        
        thumbnailImageView.layer.cornerRadius = thumbnailImageView.frame.size.width / 2
        thumbnailImageView.clipsToBounds = true
    }
}
