//
//  VarietyTranslator.swift
//  mowine
//
//  Created by Josh Freed on 2/20/17.
//  Copyright © 2017 BleepSmazz. All rights reserved.
//

import UIKit
import CoreData

protocol CoreDataTranslator {
    associatedtype Model
    func toCoreData(input: String) -> Model?
}

class VarietyTranslator: CoreDataTranslator {
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func toCoreData(input: String) -> Variety? {
        let fetchRequest: NSFetchRequest<Variety> = Variety.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name = %@", input)
        
        var variety: Variety?
        do {
            variety = try context.fetch(fetchRequest).first
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return variety
    }
}
