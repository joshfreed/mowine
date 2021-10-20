//
//  MyCellarViewModel.swift
//  mowine
//
//  Created by Josh Freed on 10/11/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import Foundation
import SwiftyBeaver
import Combine
import Model
import FirebaseCrashlytics

class MyCellarViewModel: ObservableObject {
    @Published var isEditingWine: Bool = false
    @Published var selectedWineId: String?

    @Published var redId: Int = -1
    @Published var whiteId: Int = -1
    @Published var roseId: Int = -1
    @Published var bubblyId: Int = -1
    @Published var otherId: Int = -1

    @Injected private var getWineTypesQuery: GetWineTypesQueryHandler

    init() {
        SwiftyBeaver.debug("init")
    }

    deinit {
        SwiftyBeaver.debug("deinit")
    }

    func load() async {
        do {
            let response = try await getWineTypesQuery.handle()
            redId = response.wineTypes.first { $0.name == "Red" }!.id
            whiteId = response.wineTypes.first { $0.name == "White" }!.id
            roseId = response.wineTypes.first { $0.name == "Rosé" }!.id
            bubblyId = response.wineTypes.first { $0.name == "Bubbly" }!.id
            otherId = response.wineTypes.first { $0.name == "Other" }!.id
        } catch {
            SwiftyBeaver.error("\(error)")
            Crashlytics.crashlytics().record(error: error)
        }
    }

    func onEditWine(_ wineId: String) {
        selectedWineId = wineId
        isEditingWine = true
    }
}
