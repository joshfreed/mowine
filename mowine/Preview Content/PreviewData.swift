//
//  PreviewData.swift
//  mowine
//
//  Created by Josh Freed on 10/12/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI
import Model

#if DEBUG

struct PreviewData {
    static let userId1: String = "U1"
    static let userId2: String = "U2"
}

extension View {
    func addPreviewData() -> some View {
        Task {
            try! await configurePreviewData()
        }
        
        return self
    }
}

fileprivate func configurePreviewData() async throws {
    // Dependencies
    let userRepository: UserRepository = try! JFContainer.shared.resolve()
    let wineTypeRepository: MemoryWineTypeRepository = try! JFContainer.shared.resolve()
    let wineRepository: WineRepository = try! JFContainer.shared.resolve()

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
    try await wineRepository.add(wine1)
}

#endif
