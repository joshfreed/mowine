//
//  SocialAuthViewModel.swift
//  mowine
//
//  Created by Josh Freed on 1/1/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation
import Combine
import MoWine_Application
import OSLog

@MainActor
class SocialAuthViewModel: ObservableObject {
    @Published var isSigningIn: Bool = false
    @Published var isSignInError: Bool = false
    @Published var signInError: String = ""

    @Injected private var socialAuthService: SocialAuthApplicationService
    private let logger = Logger(category: .ui)

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
        switch error {
        case SocialSignInErrors.signInCancelled: break
        default:
            logger.error("\(error)")
            CrashReporter.shared.record(error: error)
            isSignInError = true
            signInError = error.localizedDescription
        }

    }
}
