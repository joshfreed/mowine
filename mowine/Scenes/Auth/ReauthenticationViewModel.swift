//
//  ReauthenticationViewModel.swift
//  mowine
//
//  Created by Josh Freed on 12/6/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import Foundation
import MoWine_Application
import OSLog

class ReauthenticationViewModel: ObservableObject {
    @Published var showErrorAlert = false
    @Published var errorMessage: String = ""
    
    @Injected private var socialAuthService: SocialAuthService
    @Injected private var socialSignInRegistry: SocialSignInRegistry
    private let logger = Logger(category: .ui)

    func continueWith(_ type: SocialProviderType) async -> Bool {
        guard let method = socialSignInRegistry.getSignInMethod(for: type) else {
            fatalError("No sign in method registered for provider: \(type)")
        }

        do {
            let token = try await method.signIn()
            try await socialAuthService.reauthenticate(with: token)
            return true
        } catch {
            showError(error)
            return false
        }
    }

    private func showError(_ error: Error) {
        logger.error("\(error)")
        CrashReporter.shared.record(error: error)
        errorMessage = error.localizedDescription
        showErrorAlert = true
    }
}
