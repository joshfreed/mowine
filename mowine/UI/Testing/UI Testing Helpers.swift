//
//  UI Testing Helpers.swift
//  UI Testing Helpers
//
//  Created by Josh Freed on 9/11/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation
import Model

class UITestHelper {
    func logInExistingUser() async {
        if let loggedInUserJson = ProcessInfo.processInfo.environment["loggedInUser"] {
            do {
                let login = try JSONDecoder().decode(UITesting.UserLogin.self, from: Data(loggedInUserJson.utf8))
                let emailAuth: EmailAuthenticationService = try JFContainer.shared.resolve()
                try await emailAuth.signIn(emailAddress: login.emailAddress, password: login.password)
            } catch {
                fatalError("Unable to log in user")
            }
        } else {
            do {
                let signOutCommand: SignOutCommand = try JFContainer.shared.resolve()
                signOutCommand.signOut()
            } catch {
                fatalError("Unable to log out user")
            }
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
