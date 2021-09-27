//
//  GetWinesByTypeQuery.swift
//  mowine
//
//  Created by Josh Freed on 11/1/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import Foundation
import Combine
import SwiftyBeaver

public class GetWinesByTypeQuery {
    public struct WineDto {
        public let id: String
        public let name: String
        public let rating: Int
        public let type: String

        public init(id: String, name: String, rating: Int, type: String) {
            self.id = id
            self.name = name
            self.rating = rating
            self.type = type
        }
    }
    
    let wineRepository: WineRepository
    let session: Session

    private var subjects: [String: CurrentValueSubject<[WineDto], Error>] = [:]
    private var listeners: [String: MoWineListenerRegistration] = [:]
    private var sessionCancellable: AnyCancellable?

    public init(wineRepository: WineRepository, session: Session) {
        SwiftyBeaver.debug("init")
        self.wineRepository = wineRepository
        self.session = session
    }

    deinit {
        SwiftyBeaver.debug("deinit")
        listeners.values.forEach { $0.remove() }
        sessionCancellable = nil
    }

    public func getWinesByType(_ wineType: WineType) -> AnyPublisher<[WineDto], Error> {
        if subjects[wineType.name] == nil {
            subjects[wineType.name] = createSubject(for: wineType)
        }

        return AnyPublisher(subjects[wineType.name]!)
    }

    private func createSubject(for wineType: WineType) -> CurrentValueSubject<[WineDto], Error> {
        SwiftyBeaver.debug("Constructing new subject for \(wineType.name)")
        let subject = CurrentValueSubject<[WineDto], Error>([])
        subscribeToDomain(wineType: wineType)
        return subject
    }

    private func subscribeToDomain(wineType: WineType) {
        sessionCancellable = session.currentUserIdPublisher
            .removeDuplicates()
            .sink(receiveValue: { [weak self] userId in
                self?.updateSubscription(userId: userId, wineType: wineType)
            })
    }
    
    private func updateSubscription(userId: UserId?, wineType: WineType) {
        listeners[wineType.name]?.remove()

        guard let userId = userId else {
            return
        }
        
        listeners[wineType.name] = wineRepository.getWines(userId: userId, wineType: wineType) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let wines):
                let dtos = wines.map { strongSelf.toDto($0) }
                strongSelf.subjects[wineType.name]?.send(dtos)
            case .failure(let error):
                strongSelf.subjects[wineType.name]?.send(completion: .failure(error))
            }
        }
    }
    
    private func toDto(_ wine: Wine) -> WineDto {
        WineDto(id: wine.id.asString, name: wine.name, rating: Int(wine.rating), type: wine.type.name)
    }
}
