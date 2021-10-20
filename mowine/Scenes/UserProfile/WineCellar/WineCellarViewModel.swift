//
//  WineCellarViewModel.swift
//  WineCellarViewModel
//
//  Created by Josh Freed on 9/14/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation
import MoWine_Application
import SwiftyBeaver
import FirebaseCrashlytics

@MainActor
class WineCellarViewModel: ObservableObject {
    @Published var types: [String] = []

    @Injected private var getUserCellarQuery: GetUserCellarQuery

    func load(userId: String) async {
        do {
            types = try await getUserCellarQuery.execute(userId: userId)
        } catch {
            SwiftyBeaver.error("\(error)")
            Crashlytics.crashlytics().record(error: error)
        }
    }
}
