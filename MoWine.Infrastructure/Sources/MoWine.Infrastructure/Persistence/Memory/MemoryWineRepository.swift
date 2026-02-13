//
//  MemoryWineRepository.swift
//  mowine
//
//  Created by Josh Freed on 2/21/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import Combine
import MoWine_Application
import MoWine_Domain

public class MemoryWineRepository: WineRepository {
    var wines: [Wine] = []

    private var getWinesByUserSubjects: [UserId: CurrentValueSubject<[Wine], Error>] = [:]
    private let completionDelay: TimeInterval = 0.5

    private final class UncheckedSendableAction: @unchecked Sendable {
        let action: () -> Void

        init(_ action: @escaping () -> Void) {
            self.action = action
        }
    }

    private func invokeCompletionAfterDelay(_ action: @escaping () -> Void) {
        let sendableAction = UncheckedSendableAction(action)
        DispatchQueue.main.asyncAfter(deadline: .now() + completionDelay) {
            sendableAction.action()
        }
    }

    public init() {}

    public func add(_ wine: Wine) async throws {
        guard !wines.contains(where: { $0.id == wine.id }) else { return }
        wines.append(wine)
        getWinesByUserSubjects[wine.userId]?.send(getWinesSync(userId: wine.userId))
    }
    
    public func delete(_ wineId: WineId) async throws {
        if let index = wines.firstIndex(where: { $0.id == wineId }) {
            wines.remove(at: index)
        }
    }

    public func getWine(by id: WineId) async throws -> Wine? {
        wines.first { $0.id == id }
    }

    public func save(_ wine: Wine) async throws {
        guard let index = wines.firstIndex(of: wine) else {
            return
        }
        
        wines[index] = wine
    }

    public func getWines(userId: UserId, completion: @escaping (Result<[Wine], Error>) -> ()) -> MoWineListenerRegistration {
        invokeCompletionAfterDelay { [weak self] in
            guard let self else { return }
            completion(.success(self.wines.filter { $0.userId == userId }))
        }
        return FakeRegistration()
    }

    public func getWines(userId: UserId) -> AnyPublisher<[Wine], Error> {
        if let subject = getWinesByUserSubjects[userId] {
            return subject.eraseToAnyPublisher()
        } else {
            let subject = CurrentValueSubject<[Wine], Error>(getWinesSync(userId: userId))
            getWinesByUserSubjects[userId] = subject
            return subject.eraseToAnyPublisher()
        }
    }

    public func getWines(userId: UserId) async throws -> [Wine] {
        wines.filter { $0.userId == userId }
    }

    func getWinesSync(userId: UserId) -> [Wine] {
        wines.filter { $0.userId == userId }
    }

    public func getWines(userId: UserId, wineType: WineType) async throws -> [Wine] {
        wines.filter { $0.userId == userId && $0.type == wineType }
    }

    public func getWines(userId: UserId, wineType: WineType, completion: @escaping (Result<[Wine], Error>) -> ()) -> MoWineListenerRegistration {
        invokeCompletionAfterDelay { [weak self] in
            guard let self else { return }
            let matched = self.wines.filter { $0.userId == userId && $0.type == wineType }
            completion(.success(matched))
        }
        return FakeRegistration()
    }

    public func getTopWines(userId: UserId) async throws -> [Wine] {
        let topWines = wines
            .filter { $0.userId == userId }
            .sorted { $0.rating > $1.rating }
            .prefix(3)
        return Array(topWines)
    }
    
    public func getWineTypeNamesWithAtLeastOneWineLogged(userId: UserId) async throws -> [String] {
        []
    }
}
