//
//  FirestoreWine.swift
//  
//
//  Created by Josh Freed on 10/20/21.
//

import Foundation
import FirebaseFirestore
import MoWine_Domain

extension Wine {
    public static func fromFirestore(documentId: String, data: [String: Any]) -> Wine? {
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

    public func toFirestore() -> [String: Any?] {
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
