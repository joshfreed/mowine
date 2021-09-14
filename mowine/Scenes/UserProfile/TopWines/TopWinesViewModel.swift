//
//  TopWinesViewModel.swift
//  mowine
//
//  Created by Josh Freed on 3/3/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation
import Combine
import SwiftyBeaver
import Model
import FirebaseCrashlytics

@MainActor
class TopWinesViewModel: ObservableObject {
    @Published var topWines: [WineItemViewModel] = []
    @Published var errorLoadingWines = false

    private let userId: String
    private let getTopWines: GetTopWinesQuery
    
    init(userId: String, getTopWines: GetTopWinesQuery = try! JFContainer.shared.resolve()) {
        self.userId = userId
        self.getTopWines = getTopWines
    }

    func loadTopWines() async {
        errorLoadingWines = false

        do {
            let topWines = try await getTopWines.execute(userId: userId)
            self.topWines = topWines.map { .fromTopWine($0) }
        } catch {
            SwiftyBeaver.error("\(error)")
            Crashlytics.crashlytics().record(error: error)
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
            type: topWine.type,
            userId: topWine.userId
        )
    }
}
