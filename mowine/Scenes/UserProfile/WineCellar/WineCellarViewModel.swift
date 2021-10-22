//
//  WineCellarViewModel.swift
//  WineCellarViewModel
//
//  Created by Josh Freed on 9/14/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation
import MoWine_Application

@MainActor
class WineCellarViewModel: ObservableObject {
    @Published var types: [String] = []

    @Injected private var getUserCellarQuery: GetUserCellarQuery

    func load(userId: String) async {
        do {
            types = try await getUserCellarQuery.execute(userId: userId)
        } catch {
            CrashReporter.shared.record(error: error)
        }
    }
}
