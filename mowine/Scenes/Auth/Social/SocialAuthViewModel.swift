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
    
    let worker: FirstTimeWorker
    let socialSignInMethods: [SocialProviderType: SocialSignInMethod]

    init() {
        self.worker = JFContainer.shared.firstTimeWorker()
        self.socialSignInMethods = JFContainer.shared.socialSignInMethods()
    }

    init(firstTimeWorker: FirstTimeWorker, socialSignInMethods: [SocialProviderType: SocialSignInMethod]) {
        self.worker = firstTimeWorker
        self.socialSignInMethods = socialSignInMethods
    }

    func socialSignIn(type: SocialProviderType) async {
        guard let method = socialSignInMethods[type] else {
            fatalError("No sign in method registered for provider: \(type)")
        }

        isSigningIn = true

        do {
            let token = try await method.signIn()
            try await worker.login(type: type, token: token)
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
