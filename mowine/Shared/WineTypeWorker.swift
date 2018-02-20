//
//  WineTypeWorker.swift
//  mowine
//
//  Created by Josh Freed on 3/4/17.
//  Copyright © 2017 BleepSmazz. All rights reserved.
//

import UIKit
import CoreData

class WineTypeWorker {
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func getWineTypes() -> [ManagedWineType] {
        let request: NSFetchRequest<ManagedWineType> = ManagedWineType.fetchRequest()
        
        let types: [ManagedWineType]
        do {
            types = try context.fetch(request)
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        return types
    }
}
