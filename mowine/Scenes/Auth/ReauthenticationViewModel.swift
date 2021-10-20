//
//  ReauthenticationViewModel.swift
//  mowine
//
//  Created by Josh Freed on 12/6/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import Foundation
import Combine
import SwiftyBeaver
import FirebaseAuth
import GoogleSignIn
import Model
import FirebaseCrashlytics

class ReauthenticationViewModel: ObservableObject {
    @Published var showErrorAlert = false
    @Published var errorMessage: String = ""
    
    @Injected private var socialAuthService: SocialAuthService

    private let socialSignInMethods: [SocialProviderType: SocialSignInMethod]

    init() {
        self.socialSignInMethods = JFContainer.socialSignInMethods()
    }

    func continueWith(_ type: SocialProviderType) async {
        guard let method = socialSignInMethods[type] else {
            fatalError("No sign in method registered for provider: \(type)")
        }

        do {
            let token = try await method.signIn()
            try await socialAuthService.reauthenticate(with: token)
        } catch {
            showError(error)
        }
    }

    private func showError(_ error: Error) {
        SwiftyBeaver.error("\(error)")
        Crashlytics.crashlytics().record(error: error)
        errorMessage = error.localizedDescription
        showErrorAlert = true
    }
}
