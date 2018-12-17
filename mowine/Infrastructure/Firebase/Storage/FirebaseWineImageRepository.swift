//
//  FirebaseWineImageRepository.swift
//  mowine
//
//  Created by Josh Freed on 12/12/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import JFLib
import FirebaseStorage
import SwiftyBeaver

class FirebaseWineImageRepository: WineImageRepository {
    let storage: Storage
    let session: Session
    
    init(session: Session) {
        storage = Storage.storage()
        self.session = session
    }
    
    func store(wineId: WineId, image: Data, thumbnail: Data) {
        guard let userId = session.currentUserId else {
            return
        }
        
        let storageRef = storage.reference()
        
        let thumbnailName = "\(userId)/\(wineId)-thumb.png"
        storageRef.child(thumbnailName).putData(thumbnail)
        
        let imageName = "\(userId)/\(wineId).png"
        storageRef.child(imageName).putData(image)
    }
    
    func fetchThumbnail(wineId: WineId, userId: UserId, completion: @escaping (Result<Data?>) -> ()) {
        let path = "\(userId)/\(wineId)-thumb.png"
        let pathReference = storage.reference(withPath: path)
        pathReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                SwiftyBeaver.error("\(error)")
            } else {
                completion(.success(data))
            }
        }
    }
    
    func fetchPhoto(wineId: WineId, completion: @escaping (Result<Data?>) -> ()) {
        guard let userId = session.currentUserId else {
            return
        }
        
        let path = "\(userId)/\(wineId).png"
        let pathReference = storage.reference(withPath: path)
        pathReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                SwiftyBeaver.error("\(error)")
            } else {
                completion(.success(data))
            }
        }
    }
    
    func deleteImages(wineId: WineId) {
        
    }
}
