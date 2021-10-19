//
//  PreviewData.swift
//  mowine
//
//  Created by Josh Freed on 10/12/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI
import Model
import MoWine_Domain

#if DEBUG

struct PreviewData {
    static let userId1: String = "U1"
    static let userId2: String = "U2"
}

extension View {
    func addPreviewData(userId: String? = PreviewData.userId1) -> some View {
        Task {
            try! await configurePreviewData()
            try! await logInAs(userId: userId)
        }
        
        return self
    }
}

fileprivate func configurePreviewData() async throws {
    // Dependencies
    let userRepository: UserRepository = try JFContainer.shared.resolve()
    let wineTypeRepository: MemoryWineTypeRepository = try JFContainer.shared.resolve()
    let wineRepository: WineRepository = try JFContainer.shared.resolve()

    // Users
    var josh = User(id: UserId(string: PreviewData.userId1), emailAddress: "josh@jpfreed.com")
    josh.fullName = "Josh Freed"
    var maureen = User(id: UserId(string: PreviewData.userId2), emailAddress: "mshockley13@gmail.com")
    maureen.fullName = "Maureen Shockley"
    try await userRepository.add(user: josh)
    try await userRepository.add(user: maureen)

    // Wine Types / Varieties
    let red = wineTypeRepository.types[0]

    // Wines
    let wine1 = Wine(id: WineId(string: "W1"), userId: josh.id, type: red, name: "First Wine", rating: 5)
    wine1.variety = red.varieties.first
    wine1.price = "Fifty bucks"
    wine1.location = "The Wegman's on 13th st"
    try await wineRepository.add(wine1)
}

fileprivate func logInAs(userId: String?) async throws {
    let fakeSession: FakeSession = try JFContainer.shared.resolve()
    let userRepository: UserRepository = try JFContainer.shared.resolve()

    if let userId = userId {
        let userId = UserId(string: userId)
        guard let user = try await userRepository.getUserById(userId) else {
            throw UserRepositoryError.userNotFound
        }
        fakeSession.setUser(userId: userId, email: user.emailAddress)
    } else {
        fakeSession.end()
    }
}

#endif
