//
//  CoreDataWineRepository.swift
//  mowine
//
//  Created by Josh Freed on 2/21/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import CoreData
import JFLib

class CoreDataWineRepository: WineRepository {
    let container: NSPersistentContainer
    
    init(container: NSPersistentContainer) {
        self.container = container
    }
    
    func save(_ wine: Wine, completion: @escaping (Result<Wine>) -> ()) {
        
    }
    
    func getMyWines(completion: @escaping (Result<[Wine]>) -> ()) {
        
    }
    
    func delete(_ wine: Wine, completion: @escaping (EmptyResult) -> ()) {
        
    }
}
