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
import OSLog

class WineDetailsViewModel: ObservableObject {
    @Published var wine: GetWineDetailsResponse?
    @Published var wineNotFound = false

    @Injected private var mediator: Mediator
    private let logger = Logger(category: .ui)

    func load(wineId: String) async {
        do {
            wine = try await mediator.send(GetWineDetails(wineId: wineId))
        } catch GetWineDetailsErrors.wineNotFound {
            wineNotFound = true
        } catch {
            logger.error("\(error)")
            CrashReporter.shared.record(error: error)
        }
    }
}
