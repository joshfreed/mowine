//
//  EmailLogInViewModel.swift
//  mowine
//
//  Created by Josh Freed on 1/2/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation
import MoWine_Application

@MainActor
class EmailLogInViewModel: ObservableObject {
    @Published var isLoggingIn = false
    @Published var error: String = ""
    
    @Injected private var emailAuth: EmailAuthApplicationService

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
                CrashReporter.shared.record(error: error)
                self.error = "An error occurred while trying to log you in. Please try again in a few minutes."
            }
        }

        isLoggingIn = false
    }
}
