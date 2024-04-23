//
//  WineCellarViewModel.swift
//  WineCellarViewModel
//
//  Created by Josh Freed on 9/14/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation
import JFLib_Mediator
import MoWine_Application
import OSLog

@MainActor
class WineCellarViewModel: ObservableObject {
    @Published var types: [String] = []

    @Injected private var mediator: Mediator
    private let logger = Logger(category: .ui)

    func load(userId: String) async {
        do {
            let response: GetUserCellarResponse = try await mediator.send(GetUserCellar(userId: userId))
            types = response.types
        } catch {
            logger.error("\(error)")
            CrashReporter.shared.record(error: error)
        }
    }
}
