//
//  MyCellar.swift
//  mowine
//
//  Created by Josh Freed on 10/25/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation
import SwiftyBeaver
import MoWine_Application

class MyCellar: ObservableObject {
    @Published private(set) var myWines: [Wine] = [] {
        didSet {
            derive()
        }
    }

    private var winesByType: [String: [Wine]] = [:]
    private let wineFilteringService = WineFilteringService()

    func search(searchText: String) -> [Wine] {
        filter(myWines, by: searchText)
    }

    func getWinesByType(_ wineTypeId: String) -> [Wine] {
        winesByType[wineTypeId, default: []]
    }

    func filterWines(by wineTypeId: String, and searchText: String) -> [Wine] {
        let winesToFilter = getWinesByType(wineTypeId)
        return filter(winesToFilter, by: searchText)
    }

    private func filter(_ winesToFilter: [Wine], by searchText: String) -> [Wine] {
        let wineItems: [WineItemViewModel] = winesToFilter.map {
            .init(id: $0.id, name: $0.name, rating: $0.rating, type: $0.variety)
        }

        let filteredWineItems = wineFilteringService.filter(wines: wineItems, by: searchText)

        return filteredWineItems.map {
            .init(id: $0.id, name: $0.name, rating: $0.rating, type: "", variety: $0.type)
        }
    }
}

// MARK: Types

extension MyCellar {
    struct Wine: Identifiable {
        let id: String
        let name: String
        let rating: Int
        let type: String
        let variety: String

        static func from(_ dto: GetMyWinesResponse.Wine) -> Wine {
            .init(id: dto.id, name: dto.name, rating: dto.rating, type: dto.typeName, variety: dto.varietyName ?? "")
        }
    }
}

// MARK: Presentation

extension MyCellar {
    func present(_ response: GetMyWinesResponse) {
        SwiftyBeaver.verbose("presenting \(response)")
        myWines = response.wines
            .sorted(by: { $0.rating > $1.rating })
            .map { Wine.from($0) }
    }

    private func derive() {
        winesByType = myWines.reduce(into: [:]) { result, wine in
            result[wine.type, default: []].append(wine)
        }
    }
}

// MARK: Fakes

extension MyCellar {
    static func fake() -> MyCellar {
        let myCellar = MyCellar()

        myCellar.myWines = [
            .init(id: "W1", name: "My Cool Wine 2019", rating: 3, type: "Red", variety: "Merlot"),
            .init(id: "W2", name: "Real Bad Wine", rating: 1, type: "Red", variety: "Merlot")
        ]

        return myCellar
    }
}
