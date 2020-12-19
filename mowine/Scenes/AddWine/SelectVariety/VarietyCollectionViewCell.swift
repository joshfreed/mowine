//
//  VarietyCollectionViewCell.swift
//  mowine
//
//  Created by Josh Freed on 7/4/17.
//  Copyright © 2017 BleepSmazz. All rights reserved.
//

import UIKit

class VarietyCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var varietyLabel: UILabel!
    
    func configure(variety: String) {
        varietyLabel.text = variety
        varietyLabel.layer.cornerRadius = 5
        varietyLabel.clipsToBounds = true
    }
}