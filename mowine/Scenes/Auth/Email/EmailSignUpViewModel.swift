//
//  EmailSignUpViewModel.swift
//  mowine
//
//  Created by Josh Freed on 1/2/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation
import Combine
import MoWine_Application
import FirebaseCrashlytics
import SwiftyBeaver

class EmailSignUpViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String = ""
    
    @Injected private var emailAuthService: EmailAuthApplicationService

    @MainActor
    func signUp(fullName: String, emailAddress: String, password: String) async {
        errorMessage = ""
        
        guard !fullName.isEmpty, !emailAddress.isEmpty, !password.isEmpty else {
            return
        }

        isLoading = true        

        defer {
            isLoading = false
        }

        do {
            try await emailAuthService.signUp(emailAddress: emailAddress, password: password, fullName: fullName)

            // Need this b/c firebase session handler doesn't fire when linking anonymous to full account
            // Also we shouldn't have current user id listeners fire until the user account object was created
            NotificationCenter.default.post(name: .signedIn, object: nil)
        } catch {
            SwiftyBeaver.error("\(error)")
            Crashlytics.crashlytics().record(error: error)
            displaySignUpError(error)
        }
    }
    
    private func displaySignUpError(_ error: Error) {
        switch error {
        case EmailAuthenticationErrors.invalidPassword(let message):
            errorMessage = message ?? "Invalid password."
        case EmailAuthenticationErrors.emailAddressAlreadyInUse:
            errorMessage = "That email address is already associated with an account. Try signing in or resetting your password."
        default:
            errorMessage = "An error occurred while trying to create your account. Please try again in a few minutes."
        }
    }
}
