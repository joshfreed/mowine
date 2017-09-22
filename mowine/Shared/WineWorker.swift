//
//  WineWorker.swift
//  mowine
//
//  Created by Josh Freed on 9/20/17.
//  Copyright © 2017 BleepSmazz. All rights reserved.
//

import UIKit
import CoreData

class WineWorker {
    let context: NSManagedObjectContext
    let varietyTranslator: VarietyTranslator
    
    init(context: NSManagedObjectContext, varietyTranslator: VarietyTranslator) {
        self.context = context
        self.varietyTranslator = varietyTranslator
    }
    
    func addWine(type: Type, variety: Variety, photo: UIImage?, name: String, rating: Double) throws -> Wine {        
        let wine = NSEntityDescription.insertNewObject(forEntityName: "Wine", into: context) as! Wine
        wine.name = name
        wine.rating = rating
        wine.variety = variety
        
        let imageWorker = WineImageWorker()
        if let image = photo {
            wine.image = imageWorker.convertToPNGData(image: image)
            wine.thumbnail = imageWorker.createThumbnail(from: image)
        }
        
        try wine.managedObjectContext?.save()
        
        return wine
    }
}
