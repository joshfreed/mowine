//
//  WineCellarViewModel.swift
//  WineCellarViewModel
//
//  Created by Josh Freed on 9/14/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation
import Model
import SwiftyBeaver
import FirebaseCrashlytics

@MainActor
class WineCellarViewModel: ObservableObject {
    @Published var types: [String] = []

    let userId: String
    private let getUserCellarQuery: GetUserCellarQuery

    init(userId: String) {
        self.userId = userId
        getUserCellarQuery = try! JFContainer.shared.resolve()
    }

    func load() async {
        do {
            types = try await getUserCellarQuery.execute(userId: userId)
        } catch {
            SwiftyBeaver.error("\(error)")
            Crashlytics.crashlytics().record(error: error)
        }
    }
}
