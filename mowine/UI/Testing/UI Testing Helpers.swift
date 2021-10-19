//
//  UI Testing Helpers.swift
//  UI Testing Helpers
//
//  Created by Josh Freed on 9/11/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation
import Model
import FirebaseCrashlytics
import MoWine_Domain

class UITestHelper {
    func logInExistingUser() async {
        guard let loggedInUserJson = ProcessInfo.processInfo.environment["loggedInUser"] else {
            return
        }

        do {
            let login = try JSONDecoder().decode(UITesting.UserLogin.self, from: Data(loggedInUserJson.utf8))
            let emailAuth: EmailAuthenticationService = try JFContainer.shared.resolve()
            try await emailAuth.signIn(emailAddress: login.emailAddress, password: login.password)
        } catch {
            Crashlytics.crashlytics().record(error: error)
        }
    }
}

struct UITesting {}

extension UITesting {
    struct UserLogin: Decodable {
        let emailAddress: String
        let password: String
    }
}
