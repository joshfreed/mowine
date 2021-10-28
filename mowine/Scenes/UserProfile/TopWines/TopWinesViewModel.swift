//
//  TopWinesViewModel.swift
//  mowine
//
//  Created by Josh Freed on 3/3/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation
import Combine
import MoWine_Application

@MainActor
class TopWinesViewModel: ObservableObject {
    @Published var topWines: [WineItemViewModel] = []
    @Published var errorLoadingWines = false

    @Injected private var getTopWines: GetTopWinesQuery
    
    func loadTopWines(userId: String) async {
        errorLoadingWines = false

        do {
            let topWines = try await getTopWines.execute(userId: userId)
            self.topWines = topWines.map { .fromTopWine($0) }
        } catch {
            CrashReporter.shared.record(error: error)
            errorLoadingWines = true
        }
    }
}

extension WineItemViewModel {
    static func fromTopWine(_ topWine: GetTopWinesQuery.TopWine) -> WineItemViewModel {
        WineItemViewModel(
            id: topWine.id,
            name: topWine.name,
            rating: topWine.rating,
            type: topWine.type
        )
    }
}
