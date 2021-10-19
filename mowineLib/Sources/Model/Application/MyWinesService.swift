//
//  MyWinesService.swift
//  
//
//  Created by Josh Freed on 4/25/21.
//

import Foundation
import SwiftyBeaver
import Combine
import MoWine_Domain

public class MyWinesService: ObservableObject {
    @Published public var wines: [Int: [WineItemViewModel]] = [:]
    @Published public var allWines: [WineItemViewModel] = []
    @Published public var searchResults: [WineItemViewModel] = []

    private let session: Session
    private let wineTypeRepository: WineTypeRepository
    private let wineRepository: WineRepository
    private var listener: MoWineListenerRegistration?
    private var sessionCancellable: AnyCancellable?
    private let filteringService = WineFilteringService()
    private var lastSearchText: String = ""

    public init(session: Session, wineTypeRepository: WineTypeRepository, wineRepository: WineRepository) {
        self.session = session
        self.wineTypeRepository = wineTypeRepository
        self.wineRepository = wineRepository

        sessionCancellable = session.currentUserIdPublisher
            .removeDuplicates()
            .sink(receiveValue: { [weak self] userId in
                self?.loadWines(userId: userId)
            })
    }

    private func loadWines(userId: UserId?) {
        listener?.remove()
        listener = nil

        guard let userId = userId else { return }

        listener = wineRepository.getWines(userId: userId) { [weak self] result in
            switch result {
            case .success(let wines): self?.handleWinesReceived(wines: wines)
            case .failure(let error): SwiftyBeaver.error("\(error)")
            }
        }
    }

    private func handleWinesReceived(wines: [Wine]) {
        self.allWines = wines.map(WineItemViewModel.toDto)
        self.wines = wines
            .sorted(by: { $0.rating > $1.rating })
            .reduce(into: [Int: [WineItemViewModel]]()) { result, wine in
                result[wine.type.id, default: []].append(WineItemViewModel.toDto(wine))
            }
        filter(by: lastSearchText)
    }

    public func filter(by searchText: String) {
        lastSearchText = searchText
        searchResults = filteringService.filter(wines: allWines, by: searchText)
    }
}
