//
//  FirestoreWineRepository.swift
//  mowine
//
//  Created by Josh Freed on 12/12/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import JFLib
import FirebaseFirestore
import SwiftyBeaver


class FirestoreWineRepository: WineRepository {
    let db = Firestore.firestore()
    
    init() {
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
    }
    
    func add(_ wine: Wine, completion: @escaping (Result<Wine>) -> ()) {
        let data = wine.toFirestore()
        
        db.collection("wines").addDocument(data: data) { err in
            if let err = err {
                SwiftyBeaver.error("Error adding wine document: \(err)")
                completion(.failure(err))
            } else {
                completion(.success(wine))
            }
        }
    }
    
    func save(_ wine: Wine, completion: @escaping (Result<Wine>) -> ()) {
//        let data = wine.toFirestore()
//        db.collection("wines").document(wine.id.asString).setData(data, merge: true)
    }
    
    func delete(_ wine: Wine, completion: @escaping (EmptyResult) -> ()) {
        
    }
    
    func getWine(by id: WineId, completion: @escaping (Result<Wine>) -> ()) {
        
    }
    
    func getWines(userId: UserId, completion: @escaping (Result<[Wine]>) -> ()) {
        let query = db.collection("wines").whereField("userId", isEqualTo: userId.asString)
        
        query.addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                SwiftyBeaver.error("\(error)")
                completion(.failure(error))
            } else if let documents = querySnapshot?.documents {
                let wines: [Wine] = documents.compactMap { Wine.fromFirestore($0.data()) }
                completion(.success(wines))
            } else {
                fatalError("unknown error with query")
            }
        }
    }
    
    func getWines(userId: UserId, wineType: WineType, completion: @escaping (Result<[Wine]>) -> ()) {
        completion(.success([]))
    }
    
    func getTopWines(userId: UserId, completion: @escaping (Result<[Wine]>) -> ()) {
        completion(.success([]))
    }
}

extension Wine {
    static func fromFirestore(_ data: [String: Any]) -> Wine? {
        guard
            let userIdStr = data["userId"] as? String,
            let typeName = data["type"] as? String,
            let name = data["name"] as? String,
            let rating = data["rating"] as? Double
        else {
            return nil
        }
        let wineId = WineId()
        let userId = UserId(string: userIdStr)
        let wineType = WineType(name: typeName, varieties: [])
        var wine = Wine(id: wineId, userId: userId, type: wineType, name: name, rating: rating)
        return wine
    }
    
    func toFirestore() -> [String: Any] {
        var data: [String: Any] = [
            "userId": userId.asString,
            "type": type.name,
            "name": name,
            "rating": rating
        ]
        if let varietyName = variety {
            data["variety"] = varietyName
        }
        return data
    }
}
