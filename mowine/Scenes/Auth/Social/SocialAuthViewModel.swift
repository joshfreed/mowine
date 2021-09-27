//
//  SocialAuthViewModel.swift
//  mowine
//
//  Created by Josh Freed on 1/1/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation
import Combine
import SwiftyBeaver
import Model
import FirebaseCrashlytics

class SocialAuthViewModel: ObservableObject {
    @Published var isSigningIn: Bool = false
    @Published var isSignInError: Bool = false
    @Published var signInError: String = ""

    let socialAuthService: SocialAuthApplicationService

    init() {
        self.socialAuthService = try! JFContainer.shared.resolve()
    }

    init(socialAuthService: SocialAuthApplicationService) {
        self.socialAuthService = socialAuthService
    }

    func socialSignIn(type: SocialProviderType) async {
        isSigningIn = true

        do {
            try await socialAuthService.signIn(using: type)
        } catch let error {
            showError(error)
        }

        isSigningIn = false
    }

    private func showError(_ error: Error) {
        Crashlytics.crashlytics().record(error: error)
        SwiftyBeaver.error("\(error)")
        isSignInError = true
        signInError = error.localizedDescription
    }
}
