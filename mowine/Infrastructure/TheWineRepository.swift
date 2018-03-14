//
//  TheWineRepository.swift
//  mowine
//
//  Created by Josh Freed on 3/14/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import JFLib

protocol LocalWineDataStore {
    func getMyWines(completion: @escaping (Result<[Wine]>) -> ())
    func save(_ wine: Wine, completion: @escaping (Result<Wine>) -> ())
    func delete(_ wine: Wine, completion: @escaping (EmptyResult) -> ()) 
}

protocol RemoteWineDataStore {
    func getTopWines(userId: UserId, completion: @escaping (Result<[Wine]>) -> ())
}

class TheWineRepository: WineRepository {
    let local: LocalWineDataStore
    let remote: RemoteWineDataStore
    
    init(local: LocalWineDataStore, remote: RemoteWineDataStore) {
        self.local = local
        self.remote = remote
    }
    
    func getMyWines(completion: @escaping (Result<[Wine]>) -> ()) {
        local.getMyWines(completion: completion)
    }
    
    func save(_ wine: Wine, completion: @escaping (Result<Wine>) -> ()) {
        local.save(wine, completion: completion)
    }
    
    func delete(_ wine: Wine, completion: @escaping (EmptyResult) -> ()) {
        local.delete(wine, completion: completion)
    }
    
    func getTopWines(userId: UserId, completion: @escaping (Result<[Wine]>) -> ()) {
        remote.getTopWines(userId: userId, completion: completion)
    }
}
