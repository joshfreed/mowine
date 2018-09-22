//
//  CoreDataService.swift
//  mowine
//
//  Created by Josh Freed on 9/20/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import CoreData

class CoreDataService {
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func save() {
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func findManagedWine(by id: UUID) -> ManagedWine? {
        let request: NSFetchRequest<ManagedWine> = ManagedWine.fetchRequest()
        request.predicate = NSPredicate(format: "wineId == %@", id as CVarArg)
        
        do {
            return try context.fetch(request).first
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func getAllManagedWines() -> [ManagedWine] {
        let request: NSFetchRequest<ManagedWine> = ManagedWine.fetchRequest()
        
        do {
            return try context.fetch(request)
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func findManagedUser(by id: UserId) -> ManagedUser? {
        let request: NSFetchRequest<ManagedUser> = ManagedUser.fetchRequest()
        request.predicate = NSPredicate(format: "userId == %@", id.asString)
        
        do {
            return try context.fetch(request).first
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func getManagedType(for type: WineType) -> ManagedWineType? {
        let fetchRequest: NSFetchRequest<ManagedWineType> = ManagedWineType.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name = %@", type.name)
        
        do {
            return try context.fetch(fetchRequest).first
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func getManagedVariety(for variety: WineVariety) -> ManagedWineVariety? {
        let fetchRequest: NSFetchRequest<ManagedWineVariety> = ManagedWineVariety.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name = %@", variety.name)
        
        do {
            return try context.fetch(fetchRequest).first
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
