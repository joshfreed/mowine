//
//  TopWinesViewModel.swift
//  mowine
//
//  Created by Josh Freed on 3/3/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation
import Combine
import JFLib_Mediator
import MoWine_Application
import OSLog

class TopWinesViewModel: ObservableObject {
    @Published var topWines: [GetTopWinesResponse.TopWine] = []
    @Published var errorLoadingWines = false
    @Published var showWineDetails = false
    @Published var selectedWineId: String = ""

    @Injected private var mediator: Mediator
    private let logger = Logger(category: .ui)

    @MainActor
    func load(userId: String) async {
        errorLoadingWines = false

        do {
            let response: GetTopWinesResponse = try await mediator.send(GetTopWinesQuery(userId: userId))
            self.topWines = response.topWines
        } catch {
            logger.error("\(error)")
            CrashReporter.shared.record(error: error)
            errorLoadingWines = true
        }
    }

    func select(wine: GetTopWinesResponse.TopWine) {
        showWineDetails = true
        selectedWineId = wine.id
    }
}
