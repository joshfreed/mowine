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
//        entity.image = wine.photo
//        entity.thumbnail = wine.thumbnail
        
        if let price = wine.price {
            entity.price = NSDecimalNumber(string: price)
        } else {
            entity.price = nil
        }
        
        entity.type = getManagedType(for: wine.type)
        
        if let variety = wine.variety {
            entity.variety = getManagedVariety(for: variety)
        } else {
            entity.variety = nil
        }
        
        let pairings: [ManagedFood] = wine.pairings.map {
            let mf = ManagedFood(context: context)
            mf.name = $0
            return mf
        }
        entity.pairings = NSSet(array: pairings)
    }

    private func getManagedType(for type: WineType) -> ManagedWineType? {
        let fetchRequest: NSFetchRequest<ManagedWineType> = ManagedWineType.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name = %@", type.name)
        
        do {
            return try context.fetch(fetchRequest).first
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
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
            let name = entity.name,
            let managedType = entity.type,
            let type = CoreDataWineTypeTranslator.makeModel(from: managedType),
            let user = entity.user, let userIdStr = user.userId
        else {
            return nil
        }
        
        let userId = UserId(string: userIdStr)
        let wine = Wine(id: id, userId: userId, type: type, name: name, rating: entity.rating)
        
        if let managedVariety = entity.variety {
            wine.variety = CoreDataVarietyTranslator.map(from: managedVariety)
        }
        
        wine.location = entity.location
        wine.price = entity.price != nil ? entity.price!.stringValue : nil
        wine.notes = entity.notes        
        wine.thumbnail = entity.thumbnail
        
        if let pairingSet = entity.pairings, let pairings = Array(pairingSet) as? [ManagedFood] {            
            wine.pairings = pairings.compactMap { $0.name }
        }
        
        return wine
    }
}
