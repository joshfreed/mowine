//
//  WineDetailsViewModel.swift
//  mowine
//
//  Created by Josh Freed on 11/13/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation
import JFLib_Mediator
import MoWine_Application

class WineDetailsViewModel: ObservableObject {
    @Published var wine: GetWineDetailsResponse?
    @Published var wineNotFound = false

    @Injected private var mediator: Mediator

    func load(wineId: String) async {
        do {
            wine = try await mediator.send(GetWineDetails(wineId: wineId))
        } catch GetWineDetailsErrors.wineNotFound {
            wineNotFound = true
        } catch {
            CrashReporter.shared.record(error: error)
        }
    }
}
