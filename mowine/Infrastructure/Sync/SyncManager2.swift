//
//  SyncManager2.swift
//  mowine
//
//  Created by Josh Freed on 9/30/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import JFLib
import SwiftyBeaver

class SyncManager2<TRemoteDataStore, TLocalDataStore, TDataMapper>
where
    TRemoteDataStore: RemoteDataStore,
    TLocalDataStore: LocalDataStore,
    TDataMapper: DataMapper,
    TDataMapper.RemoteType == TRemoteDataStore.Object,
    TDataMapper.LocalType == TLocalDataStore.L
{
    let remoteDataStore: TRemoteDataStore
    let localDataStore: TLocalDataStore
    let mapper: TDataMapper
    
    init(remoteDataStore: TRemoteDataStore, localDataStore: TLocalDataStore, mapper: TDataMapper) {
        self.remoteDataStore = remoteDataStore
        self.localDataStore = localDataStore
        self.mapper = mapper
    }
    
    private var entityName: String {
        return String(describing: TRemoteDataStore.Object.self)
    }
    
    func syncObjects(completion: @escaping (EmptyResult) -> ()) {
        SwiftyBeaver.info("Starting sync for \(entityName)")

        remoteDataStore.fetchAll() { result in
            switch result {
            case .success(let remoteObjects): self.doSync(remoteObjects, completion: completion)
            case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    private func doSync(_ remoteObjects: [TRemoteDataStore.Object], completion: @escaping (EmptyResult) -> ()) {
        syncRemoteToLocal(remoteObjects) { result in
            switch result {
            case .success: self.syncLocalToRemote(completion: completion)
            case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    func syncRemoteToLocal(_ remoteObjects: [TRemoteDataStore.Object], completion: @escaping(EmptyResult) -> ()) {
        localDataStore.open {
            do {
                try self.syncRemoteToLocal(remoteObjects)
                completion(.success)
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    private func syncRemoteToLocal(_ remoteObjects: [TRemoteDataStore.Object]) throws {
        for remoteObject in remoteObjects {
            try insertOrUpdateLocalFromRemote(remoteObject)
        }
        try deleteLocalObjectsNotInRemote(remoteObjects)
        localDataStore.save()
    }
    
    private func insertOrUpdateLocalFromRemote(_ remoteObject: TRemoteDataStore.Object) throws {
        if let localObject = try localDataStore.getFor(remoteObject.getId()!) {
            if shouldUpdateLocalFromRemote(localObject: localObject, remoteObject: remoteObject) {
                SwiftyBeaver.verbose("[\(entityName)] Updating local object with remote changes")
                try mapper.map(from: remoteObject, to: localObject)
                try localDataStore.update(localObject)
                localObject.markSynced()
            }
        } else {
            SwiftyBeaver.verbose("[\(entityName)] Inserting new object from remote")
            let newLocalObject = try mapper.create(from: remoteObject)
            try localDataStore.insert(newLocalObject)
            newLocalObject.markSynced()
        }
    }
    
    private func shouldUpdateLocalFromRemote(localObject: TLocalDataStore.L, remoteObject: TRemoteDataStore.Object) -> Bool {
        guard let remoteUpdatedAt = remoteObject.getUpdatedAt() else {
            let message = "[\(entityName)] Remote object does not have a valid updatedAt value. " +
                          "Unable to update local object from remote. Id: \(remoteObject.getId() ?? "(nil)")"
            SwiftyBeaver.warning(message)
            return false
        }
        
        guard let localUpdatedAt = localObject.getUpdatedAt() else {
            let message = "[\(entityName)] Local object does not have a valid updatedAt value. " +
                            "Unable to update local object from remote. Id: \(localObject.getId() ?? "(nil)")"
            SwiftyBeaver.warning(message)
            return false
        }
        
        guard let syncState = localObject.getSyncStatus() else {
            SwiftyBeaver.warning("[\(entityName)] Local object does not have a valid sync state. Id: \(localObject.getId() ?? "(nil)")")
            return false
        }
        
        // Local object is not modified; and the remote object was updated elsewhere after the last time this local object was updated
        if syncState == .synced && remoteUpdatedAt > localUpdatedAt {
            return true
        }
        
        // The local object is modified; but the remote object's updated date is after the date this local object was updated
        // we're going with last updated wins
        if syncState == .modified && remoteUpdatedAt > localUpdatedAt {
            return true
        }
        
        return false
    }
    
    private func deleteLocalObjectsNotInRemote(_ remoteObjects: [TRemoteDataStore.Object]) throws {
        let localObjects: [TLocalDataStore.L] = try localDataStore.getAll()
        
        for localObject in localObjects {
            if let syncState = localObject.getSyncStatus(), syncState == .created {
                continue
            }

            if !remoteObjects.contains(where: { $0.getId() == localObject.getId() }) {
                SwiftyBeaver.debug("[\(entityName)] Deleting local object not found in remote")
                try localDataStore.delete(localObject)
            }
        }
    }
    
    func syncLocalToRemote(completion: @escaping (EmptyResult) -> ()) {
        do {
            let localObjects: [TLocalDataStore.L] = try localDataStore.getAll()
            let group = DispatchGroup()
            
            for localObject in localObjects {
                switch localObject.getSyncStatus() {
                case .none: SwiftyBeaver.warning("[\(entityName)] Found local object w/o a valid sync state. Id: \(localObject.getId() ?? "nil")")
                case .some(.synced): break
                case .some(.created): try self.sendLocalObjecToRemote(localObject, dispatchGroup: group)
                case .some(.modified): try self.updateRemoteFromLocal(localObject, dispatchGroup: group)
                case .some(.deleted): try self.deleteObjectFromRemote(localObject, dispatchGroup: group)
                }
            }
            
            group.notify(queue: DispatchQueue.global(qos: .background)) {
                self.localDataStore.save()
                completion(.success)
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    func sendLocalObjecToRemote(_ localObject: TLocalDataStore.L, dispatchGroup: DispatchGroup) throws {
        SwiftyBeaver.info("[\(entityName)] Sending new local object to remote")
        dispatchGroup.enter()
        let remoteObject = try mapper.construct(from: localObject)
        remoteDataStore.insert(remoteObject) { result in
            switch result {
            case .success: localObject.markSynced()
            case .failure(let error): SwiftyBeaver.error("[\(self.entityName)] \(error)")
            }
            dispatchGroup.leave()
        }
    }
    
    func updateRemoteFromLocal(_ localObject: TLocalDataStore.L, dispatchGroup: DispatchGroup) throws {
        SwiftyBeaver.info("[\(entityName)] Sending updated local object to remote")
        dispatchGroup.enter()
        let remoteObject = try mapper.construct(from: localObject)
        remoteDataStore.update(remoteObject) { result in
            switch result {
            case .success: localObject.markSynced()
            case .failure(let error): SwiftyBeaver.error("[\(self.entityName)] \(error)")
            }
            dispatchGroup.leave()
        }
    }
    
    func deleteObjectFromRemote(_ localObject: TLocalDataStore.L, dispatchGroup: DispatchGroup) throws {
        SwiftyBeaver.info("[\(entityName)] Removing deleteing local object from remote")
        dispatchGroup.enter()
        let remoteObject = try mapper.construct(from: localObject)
        remoteDataStore.delete(remoteObject) { result in
            switch result {
            case .success: localObject.markSynced()
            case .failure(let error): SwiftyBeaver.error("[\(self.entityName)] \(error)")
            }
            dispatchGroup.leave()
        }
    }
}

protocol RemoteObject: class {
    func getId() -> String?
    func getUpdatedAt() -> Date?
}

protocol LocalObject: class {
    func getId() -> String?
    func getUpdatedAt() -> Date?
    func getSyncStatus() -> SyncStatus?
    func markSynced()
}

protocol RemoteDataStore {
    associatedtype Object: RemoteObject
    func fetchAll(completion: @escaping (Result<[Object]>) -> ())
    func insert(_ object: Object, completion: @escaping (EmptyResult) -> ())
    func update(_ object: Object, completion: @escaping (EmptyResult) -> ())
    func delete(_ object: Object, completion: @escaping (EmptyResult) -> ())
}

protocol LocalDataStore {
    associatedtype L: LocalObject
    func delete(_ entity: L) throws
    func getAll() throws -> [L]
    func getFor(_ id: String) throws -> L?
    func insert(_ entity: L) throws
    func open(completion: @escaping () -> ())
    func save()
    func update(_ entity: L) throws
}

protocol DataMapper {
    associatedtype RemoteType
    associatedtype LocalType
    func create(from remote: RemoteType) throws -> LocalType
    func construct(from local: LocalType) throws -> RemoteType
    func map(from remote: RemoteType, to local: LocalType) throws
    func map(from local: LocalType, to remote: RemoteType) throws
}
