//
//  EmailLogInViewModel.swift
//  mowine
//
//  Created by Josh Freed on 1/2/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation
import SwiftyBeaver
import Model
import FirebaseCrashlytics

@MainActor
class EmailLogInViewModel: ObservableObject {
    @Published var isLoggingIn = false
    @Published var error: String = ""
    
    let emailAuth: EmailAuthenticationService

    init() {
        self.emailAuth = try! JFContainer.shared.container.resolve()
    }

    init(emailAuth: EmailAuthenticationService) {
        self.emailAuth = emailAuth
    }

    func logIn(emailAddress: String, password: String) async {
        error = ""

        guard !emailAddress.isEmpty, !password.isEmpty else {
            return
        }

        isLoggingIn = true

        do {
            try await emailAuth.signIn(emailAddress: emailAddress, password: password)
        } catch let error {
            switch error {
            case
                EmailAuthenticationErrors.userNotFound,
                EmailAuthenticationErrors.notAuthorized:
                self.error = "Login failed. Please check your email and password and try again."
            default:
                Crashlytics.crashlytics().record(error: error)
                SwiftyBeaver.error("\(error)")
                self.error = "An error occurred while trying to log you in. Please try again in a few minutes."
            }
        }

        isLoggingIn = false
    }
}
