//
//  FirebaseWineImageRepository.swift
//  mowine
//
//  Created by Josh Freed on 12/12/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import JFLib

class FirebaseWineImageRepository: WineImageRepository {
    func store(wineId: WineId, image: Data, thumbnail: Data) {
        
    }
    
    func fetchThumbnail(wineId: WineId, userId: UserId, completion: @escaping (Result<Data?>) -> ()) {
        completion(.success(nil))
    }
    
    func fetchPhoto(wineId: WineId, completion: @escaping (Result<Data?>) -> ()) {
        completion(.success(nil))
    }
    
    func deleteImages(wineId: WineId) {
        
    }
}
