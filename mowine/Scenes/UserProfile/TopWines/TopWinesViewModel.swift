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

@MainActor
class TopWinesViewModel: ObservableObject {
    @Published var topWines: [GetTopWinesQueryResponse.TopWine] = []
    @Published var errorLoadingWines = false
    @Published var showWineDetails = false
    @Published var selectedWineId: String = ""

    @Injected private var mediator: Mediator
    
    func loadTopWines(userId: String) async {
        errorLoadingWines = false

        do {
            let response: GetTopWinesQueryResponse = try await mediator.send(GetTopWinesQuery(userId: userId))
            self.topWines = response.topWines
        } catch {
            CrashReporter.shared.record(error: error)
            errorLoadingWines = true
        }
    }

    func select(wine: GetTopWinesQueryResponse.TopWine) {
        showWineDetails = true
        selectedWineId = wine.id
    }
}
