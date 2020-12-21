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
import FBSDKLoginKit
import GoogleSignIn

class ReauthenticationViewModel: ObservableObject {
    @Published var showEmailReauth = false
    @Published var showErrorAlert = false
    @Published var errorMessage: String = ""
    
    var onSuccess: () -> Void
    var onCancel: () -> Void

    let socialSignInMethods: [SocialProviderType: SocialSignInMethod]
    private(set) var socialAuthService: SocialAuthService!

    init(onSuccess: @escaping () -> Void, onCancel: @escaping () -> Void) {
        self.onSuccess = onSuccess
        self.onCancel = onCancel
        self.socialAuthService = try! JFContainer.shared.container.resolve()
        self.socialSignInMethods = JFContainer.shared.socialSignInMethods()
    }
    
    func cancel() {
        onCancel()
    }
    
    func continueWith(_ loginType: LoginType) {
        switch loginType {
        case .email: continueWithEmail()
        case .social(let type): socialSignIn(type: type)
        }
    }
    
    // MARK: Email
    
    private func continueWithEmail() {
        showEmailReauth = true
    }
    
    // MARK: Login Providers

    private func socialSignIn(type: SocialProviderType) {
        guard let method = socialSignInMethods[type] else {
            fatalError("No sign in method registered for provider: \(type)")
        }

        method.signIn { result in
            switch result {
            case .success(let token): self.reauth(with: token)
            case .failure(let error): self.showError(error)
            }
        }
    }

    private func reauth(with token: SocialToken) {
        socialAuthService.reauthenticate(with: token) { result in
            switch result {
            case .success: self.onSuccess()
            case .failure(let error): self.showError(error)
            }
        }
    }

    // MARK: View Model Factories
    
    func makeEmailReauthViewModel() -> EmailReauthViewModel {
        EmailReauthViewModel(session: JFContainer.shared.session, onSuccess: onSuccess)
    }

    // MARK: Utilities

    private func showError(_ error: Error) {
        SwiftyBeaver.error("\(error)")
        errorMessage = error.localizedDescription
        showErrorAlert = true
    }
}
