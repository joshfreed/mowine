//
//  WineEntityBuilder.swift
//  mowine
//
//  Created by Josh Freed on 2/22/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import CoreData

class CoreDataWineTranslator {
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func map(from wine: Wine, to entity: ManagedWine) {
        entity.wineId = wine.id
        entity.name = wine.name
        entity.rating = wine.rating
        entity.location = wine.location
        entity.notes = wine.notes
        entity.image = wine.photo
        entity.thumbnail = wine.thumbnail
        
        if let price = wine.price {
            entity.price = NSDecimalNumber(value: price)
        } else {
            entity.price = nil
        }
        
        entity.variety = getManagedVariety(for: wine.variety)
        
        let pairings: [ManagedFood] = wine.pairings.map {
            let mf = ManagedFood(context: context)
            mf.name = $0
            return mf
        }
        entity.pairings = NSSet(array: pairings)
    }

    private func getManagedVariety(for variety: WineVariety) -> ManagedWineVariety? {
        let fetchRequest: NSFetchRequest<ManagedWineVariety> = ManagedWineVariety.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name = %@", variety.name)
        
        do {
            return try context.fetch(fetchRequest).first
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func map(from entity: ManagedWine) -> Wine? {
        guard
            let id = entity.wineId,
            let managedVariety = entity.variety,
            let variety = CoreDataVarietyTranslator.map(from: managedVariety),
            let name = entity.name
        else {
            return nil
        }
        
        let wine = Wine(
            id: id,
            type: WineType(name: "Fuck", varieties: []),
            variety: variety,
            name: name,
            rating: entity.rating
        )
        
        wine.location = entity.location
        wine.price = entity.price != nil ? Double(truncating: entity.price!) : nil
        wine.notes = entity.notes        
        wine.photo = entity.image
        wine.thumbnail = entity.thumbnail
        
        if let pairingSet = entity.pairings, let pairings = Array(pairingSet) as? [ManagedFood] {            
            wine.pairings = pairings.flatMap { $0.name }
        }
        
        return wine
    }
}
