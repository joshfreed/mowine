//
//  SearchMyCellarQuery.swift
//  mowine
//
//  Created by Josh Freed on 10/29/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import Foundation
import Combine
import SwiftyBeaver

class SearchMyCellarQuery {
    struct WineDto {
        let id: String
        let name: String
        let rating: Int
        let type: String
    }

    let wineRepository: WineRepository
    let session: Session

    private(set) var results = CurrentValueSubject<[WineDto], Error>([])

    private var listener: MoWineListenerRegistration?
    private var wines: [Wine] = []
    private var searchText: String = ""
    private var sessionCancellable: AnyCancellable?

    init(wineRepository: WineRepository, session: Session) {
        SwiftyBeaver.debug("init")
        self.wineRepository = wineRepository
        self.session = session
        startListening()
    }

    deinit {
        SwiftyBeaver.debug("deinit")
        listener?.remove()
        sessionCancellable = nil
    }

    private func startListening() {
        sessionCancellable = session.currentUserIdPublisher
            .removeDuplicates()
            .sink(receiveValue: { [weak self] userId in
                self?.updateSubscription(userId)
            })
    }
    
    private func updateSubscription(_ userId: UserId?) {
        listener?.remove()
        
        guard let userId = userId else {
            return
        }
        
        listener = wineRepository.getWines(userId: userId) { [weak self] result in
            SwiftyBeaver.debug("getWines was updated")

            switch result {
            case .success(let wines):
                self?.wines = wines
                self?.updateResults()
            case .failure(let error):
                self?.results.send(completion: .failure(error))
            }
        }
    }

    func searchMyCellar(searchText: String) {
        SwiftyBeaver.debug("Searching my cellar for: \(searchText)")
        self.searchText = searchText
        updateResults()
    }

    private func updateResults() {
        let allWines = wines.map { toDto($0) }
        let matched = filter(allWines, using: searchText)
        results.send(matched)
    }

    private func filter(_ wines: [WineDto], using searchText: String) -> [WineDto] {
        if searchText.isEmpty {
            return wines
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

    private func toDto(_ wine: Wine) -> WineDto {
        WineDto(id: wine.id.asString, name: wine.name, rating: Int(wine.rating), type: wine.type.name)
    }
}
