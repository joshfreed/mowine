//
//  WineFilteringService.swift
//  
//
//  Created by Josh Freed on 5/1/21.
//

import Foundation

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
