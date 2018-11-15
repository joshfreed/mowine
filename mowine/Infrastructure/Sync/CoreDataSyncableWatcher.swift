//
//  CoreDataSyncableWatcher.swift
//  mowine
//
//  Created by Josh Freed on 11/15/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import CoreData
import SwiftyBeaver

protocol CoreDataSyncable: CoreDataObject, LocalObject {
    var syncState: Int16 { get set }
    var updatedAt: Date? { get set }
}

extension CoreDataSyncable {
    func getUpdatedAt() -> Date? {
        return updatedAt
    }
    
    func getSyncStatus() -> SyncStatus? {
        return SyncStatus(rawValue: Int(syncState))
    }
    
    func markSynced() {
        syncState = Int16(SyncStatus.synced.rawValue)
    }
}

class CoreDataSyncableWatcher {
    init(container: NSPersistentContainer) {
        NotificationCenter.default.addObserver(self, selector: #selector(contextWillSave), name: .NSManagedObjectContextWillSave, object: container.viewContext)
    }
    
    @objc func contextWillSave(n: Notification) {
        guard let context = n.object as? NSManagedObjectContext else { return }
        
        SwiftyBeaver.debug("NSManagedObjectContextWillSave")

        let inserts = context.insertedObjects
        if inserts.count > 0 {
            for insert in inserts {
                if let syncable = insert as? CoreDataSyncable {
                    syncable.syncState = Int16(SyncStatus.created.rawValue)
                    syncable.updatedAt = Date()
                }
            }
            SwiftyBeaver.debug("---- INSERTS ----")
            SwiftyBeaver.debug(inserts)
            SwiftyBeaver.debug("+++++++++++++++++")
        }
        
        let updates = context.updatedObjects
        if updates.count > 0 {
            SwiftyBeaver.debug("---- UPDATES ----")
            for update in updates {
                if let syncable = update as? CoreDataSyncable {
                    if !update.changedValues().contains(where: { key, value in key == "syncState" }) {
                        if syncable.syncState == Int16(SyncStatus.synced.rawValue) {
                            syncable.syncState = Int16(SyncStatus.modified.rawValue)
                        }
                    }
                                        
                    syncable.updatedAt = Date()
                }
                SwiftyBeaver.debug(update.changedValues())
            }
            SwiftyBeaver.debug("+++++++++++++++++")
        }
        
        let deletes = context.deletedObjects
        if deletes.count > 0 {
            SwiftyBeaver.debug("---- DELETES ----")
            SwiftyBeaver.debug(deletes)
            SwiftyBeaver.debug("+++++++++++++++++")
        }
    }
}
