//
//  FirestoreWineRepository.swift
//  mowine
//
//  Created by Josh Freed on 12/12/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import FirebaseFirestore
import SwiftyBeaver
import FirebaseCrashlytics
import Model

class FirestoreWineRepository: WineRepository {
    let db = Firestore.firestore()
    
    init() {
        
    }
    
    func add(_ wine: Wine, completion: @escaping (Result<Wine, Error>) -> ()) {
        let data = wine.toFirestore()
        
        db.collection("wines").document(wine.id.asString).setData(data as [String: Any]) { err in
            if let err = err {
                SwiftyBeaver.error("Error adding wine document: \(err)")
                Crashlytics.crashlytics().record(error: err)
                completion(.failure(err))
            } else {
                completion(.success(wine))
            }
        }
    }
    
    func save(_ wine: Wine, completion: @escaping (Result<Wine, Error>) -> ()) {
        let data = wine.toFirestore()
        db.collection("wines").document(wine.id.asString).setData(data as [String: Any], merge: true)
        completion(.success(wine))
    }
    
    func delete(_ wine: Wine, completion: @escaping (Result<Void, Error>) -> ()) {
        db.collection("wines").document(wine.id.asString).delete() { err in
            if let err = err {
                SwiftyBeaver.error("Error deleting wine document: \(err)")
                Crashlytics.crashlytics().record(error: err)
                completion(.failure(err))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func getWine(by id: WineId, completion: @escaping (Result<Wine, Error>) -> ()) {
        SwiftyBeaver.info("getWine \(id)")

        let docRef = db.collection("wines").document(id.asString)

        docRef.getDocument(source: .cache) { (document, error) in
            if let error = error {
                SwiftyBeaver.error("\(error)")
                Crashlytics.crashlytics().record(error: error)
                completion(.failure(error))
                return
            }
            
            if let document = document,
                document.exists,
                let data = document.data(),
                let wine = Wine.fromFirestore(documentId: document.documentID, data: data)
            {
                completion(.success(wine))
            } else {
                completion(.failure(WineRepositoryError.notFound))
            }
        }
    }
    
    func getWines(userId: UserId, completion: @escaping (Result<[Wine], Error>) -> ()) -> MoWineListenerRegistration {
        let query = db
            .collection("wines")
            .whereField("userId", isEqualTo: userId.asString)
        
        let listener = query.addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                SwiftyBeaver.error("\(error)")
                Crashlytics.crashlytics().record(error: error)
                completion(.failure(error))
            } else if let documents = querySnapshot?.documents {
                let wines: [Wine] = documents.compactMap { Wine.fromFirestore(documentId: $0.documentID, data: $0.data()) }
                completion(.success(wines))
            } else {
                fatalError("unknown error with query")
            }
        }

        return MyFirebaseListenerRegistration(wrapped: listener)
    }
    
    func getWines(userId: UserId, wineType: WineType, completion: @escaping (Result<[Wine], Error>) -> ()) -> MoWineListenerRegistration {
        SwiftyBeaver.info("getWines \(userId) \(wineType.name)")

        let query = db
            .collection("wines")
            .whereField("userId", isEqualTo: userId.asString)
            .whereField("type", isEqualTo: wineType.name)
        
        let listener = query.addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                SwiftyBeaver.error("\(error)")
                Crashlytics.crashlytics().record(error: error)
                completion(.failure(error))
            } else if let documents = querySnapshot?.documents {
                let wines: [Wine] = documents.compactMap { Wine.fromFirestore(documentId: $0.documentID, data: $0.data()) }
                completion(.success(wines))
            } else {
                fatalError("unknown error with query")
            }
        }

        return MyFirebaseListenerRegistration(wrapped: listener)
    }
    
    func getTopWines(userId: UserId, completion: @escaping (Result<[Wine], Error>) -> ()) {
        SwiftyBeaver.info("getTopWines \(userId)")

        let query = db
            .collection("wines")
            .whereField("userId", isEqualTo: userId.asString)
            .order(by: "rating", descending: true)
            .limit(to: 3)
        
        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                SwiftyBeaver.error("\(error)")
                Crashlytics.crashlytics().record(error: error)
                completion(.failure(error))
            } else if let documents = querySnapshot?.documents {
                let wines: [Wine] = documents.compactMap { Wine.fromFirestore(documentId: $0.documentID, data: $0.data()) }
                completion(.success(wines))
            } else {
                fatalError("unknown error with query")
            }
        }
    }
    
    func getWineTypeNamesWithAtLeastOneWineLogged(userId: UserId, completion: @escaping (Result<[String], Error>) -> ()) {
        let query = db.collection("wines").whereField("userId", isEqualTo: userId.asString)
        
        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                SwiftyBeaver.error("\(error)")
                Crashlytics.crashlytics().record(error: error)
                completion(.failure(error))
            } else {
                if let documents = querySnapshot?.documents {
                    let wineTypeNames: [String] = documents.compactMap {
                        let data = $0.data()
                        return data["type"] as? String
                    }
                    completion(.success(wineTypeNames))
                } else {
                    completion(.success([]))
                }
            }
        }
    }
}

extension Wine {
    static func fromFirestore(documentId: String, data: [String: Any]) -> Wine? {
        guard
            let userIdStr = data["userId"] as? String,
            let typeName = data["type"] as? String,
            let name = data["name"] as? String,
            let rating = data["rating"] as? Double
        else {
            return nil
        }
        let wineId = WineId(string: documentId)
        let userId = UserId(string: userIdStr)
        let wineType = WineType(name: typeName, varieties: [])
        let wine = Wine(id: wineId, userId: userId, type: wineType, name: name, rating: rating)
        
        if let varietyName = data["variety"] as? String {
            wine.variety = WineVariety(name: varietyName)
        }
        
        wine.location = data["location"] as? String
        wine.notes = data["notes"] as? String
        wine.price = data["price"] as? String
        
        if let createdAtStr = data["createdAt"] as? String, let createdAt = ISO8601DateFormatter().date(from: createdAtStr) {
            wine.createdAt = createdAt
        }
        
        if let pairingsArray = data["pairings"] as? [String] {
            wine.pairings = pairingsArray
        }
        
        return wine
    }
    
    func toFirestore() -> [String: Any?] {
        var data: [String: Any?] = [
            "userId": userId.asString,
            "type": type.name,
            "name": name,
            "rating": rating,
            "createdAt": ISO8601DateFormatter().string(from: createdAt),
            "pairings": pairings
        ]
        
        if let variety = variety {
            data["variety"] = variety.name
        } else {
            data["variety"] = nil as Any?
        }

        if let location = location {
            data["location"] = location
        }
        if let notes = notes {
            data["notes"] = notes
        }
        if let price = price {
            data["price"] = price
        }
        return data
    }
}
