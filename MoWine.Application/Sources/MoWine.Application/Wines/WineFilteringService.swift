//
//  WineFilteringService.swift
//  
//
//  Created by Josh Freed on 5/1/21.
//

import Foundation
import MoWine_Domain

public struct WineItemViewModel: Identifiable {
    public var id: String
    public var name: String
    public var rating: Int
    public var type: String

    public init(id: String, name: String, rating: Int, type: String) {
        self.id = id
        self.name = name
        self.rating = rating
        self.type = type
    }

    public static func toDto(_ wine: Wine) -> WineItemViewModel {
        .init(id: wine.id.asString, name: wine.name, rating: Int(wine.rating), type: wine.type.name)
    }
}

public class WineFilteringService {
    public init() {}

    public func filter(wines: [WineItemViewModel], by searchText: String) -> [WineItemViewModel] {
        if searchText.isEmpty {
            return []
        }

        let searchWords = searchText.lowercased().words

        var matchedWines = wines

        for word in searchWords {
            matchedWines = matchedWines.filter {
                $0.name.lowercased().words.contains { $0.lowercased().starts(with: word) }
            }
        }

        return matchedWines
    }
}
