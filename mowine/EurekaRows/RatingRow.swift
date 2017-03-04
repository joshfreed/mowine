//
//  RatingRow.swift
//  mowine
//
//  Created by Josh Freed on 1/31/17.
//  Copyright © 2017 BleepSmazz. All rights reserved.
//

import UIKit
import Eureka
import Cosmos

class RatingCell: Cell<Double>, CellType {
    @IBOutlet weak var cosmosView: CosmosView!
    
    public override func setup() {
        super.setup()
        cosmosView.didTouchCosmos = { rating in
            self.row.value = rating
        }
    }
    
    public override func update() {
        super.update()
        cosmosView.rating = (row as! RatingRow).value ?? 0
    }
}

final class RatingRow: Row<RatingCell>, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<RatingCell>(nibName: "RatingCell")
    }
}
