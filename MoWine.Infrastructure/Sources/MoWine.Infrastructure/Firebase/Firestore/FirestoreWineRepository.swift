//
//  FirestoreWineRepository.swift
//  mowine
//
//  Created by Josh Freed on 12/12/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import SwiftyBeaver
import Combine
import FirebaseFirestore
import FirebaseFirestoreCombineSwift
import FirebaseCrashlytics
import JFLib_Combine
import MoWine_Application
import MoWine_Domain

public class FirestoreWineRepository: WineRepository {
    let db = Firestore.firestore()

    public init() {
        SwiftyBeaver.verbose("init")
    }

    deinit {
        SwiftyBeaver.verbose("deinit")
    }

    public func add(_ wine: Wine) async throws {
        let data = wine.toFirestore() as [String: Any]
        try await db.collection("wines").document(wine.id.asString).setData(data)
    }
    
    public func save(_ wine: Wine) async throws {
        let data = wine.toFirestore()
        try await db.collection("wines").document(wine.id.asString).setData(data as [String: Any], merge: true)
    }

    public func delete(_ wineId: WineId) async throws {
        try await db.collection("wines").document(wineId.asString).delete()
    }

    public func getWine(by id: WineId) async throws -> Wine? {
        SwiftyBeaver.info("getWine \(id)")

        let docRef = db.collection("wines").document(id.asString)

        let document = try await docRef.getDocument()

        guard
            let data = document.data(),
            let wine = Wine.fromFirestore(documentId: document.documentID, data: data)
        else {
            return nil
        }

        return wine
    }

    public func getWines(userId: UserId) -> AnyPublisher<[Wine], Error> {
        let query = db
            .collection("wines")
            .whereField("userId", isEqualTo: userId.asString)

        return query
            .snapshotPublisher()
            .map { snapshot in snapshot.documents }
            .map { documents in documents.compactMap { Wine.fromFirestore(documentId: $0.documentID, data: $0.data()) } }
            .eraseToAnyPublisher()
    }

    public func getWines(userId: UserId, wineType: WineType, completion: @escaping (Result<[Wine], Error>) -> ()) -> MoWineListenerRegistration {
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

    public func getWines(userId: UserId) async throws -> [Wine] {
        SwiftyBeaver.info("getWines \(userId)")

        let query = db
            .collection("wines")
            .whereField("userId", isEqualTo: userId.asString)
        let querySnapshot = try await query.getDocuments()
        let wines: [Wine] = querySnapshot.documents.compactMap { Wine.fromFirestore(documentId: $0.documentID, data: $0.data()) }
        return wines
    }

    public func getTopWines(userId: UserId) async throws -> [Wine] {
        SwiftyBeaver.info("getTopWines \(userId)")

        let query = db
            .collection("wines")
            .whereField("userId", isEqualTo: userId.asString)
            .order(by: "rating", descending: true)
            .limit(to: 3)

        let querySnapshot = try await query.getDocuments()
        let wines: [Wine] = querySnapshot.documents.compactMap { Wine.fromFirestore(documentId: $0.documentID, data: $0.data()) }
        return wines
    }
    
    public func getWineTypeNamesWithAtLeastOneWineLogged(userId: UserId) async throws -> [String] {
        let query = db.collection("wines").whereField("userId", isEqualTo: userId.asString)

        let querySnapshot = try await query.getDocuments()

        let wineTypeNames: [String] = querySnapshot.documents.compactMap {
            let data = $0.data()
            return data["type"] as? String
        }

        return wineTypeNames
    }
}
