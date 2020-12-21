//
//  SignInViewModel.swift
//  mowine
//
//  Created by Josh Freed on 12/19/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import Foundation
import Combine

import SwiftyBeaver

class SignInViewModel: ObservableObject {
    @Published var isSigningIn: Bool = false
    @Published var isSignInError: Bool = false
    @Published var signInError: String = ""
    
    var onEmailSignIn: () -> Void = { }
    var onEmailSignUp: () -> Void = { }
    var onSocialSignInSuccess: () -> Void = { }
    
    let worker: FirstTimeWorker
    let socialSignInMethods: [SocialProviderType: SocialSignInMethod]
    
    init(firstTimeWorker: FirstTimeWorker) {
        self.worker = firstTimeWorker
        self.socialSignInMethods = JFContainer.shared.socialSignInMethods()
    }
    
    func continueWith(_ loginType: LoginType) {
        switch loginType {
        case .email: onEmailSignUp()
        case .social(let type): socialSignIn(type: type)
        }
    }
    
    // MARK: Sign in with email
    
    func signInWithEmail() {
        onEmailSignIn()
    }
    
    // MARK: Sign in with social provider
    
    func socialSignIn(type: SocialProviderType) {
        guard let method = socialSignInMethods[type] else {
            fatalError("No sign in method registered for provider: \(type)")
        }
        
        method.signIn { result in
            switch result {
            case .success(let token): self.linkToSession(type: type, token: token)
            case .failure(let error): self.showError(error)
            }
        }
    }
    
    private func linkToSession(type: SocialProviderType, token: SocialToken) {
        isSigningIn = true
        
        worker.login(type: type, token: token) { result in
            self.isSigningIn = false
            
            switch result {
            case .success: self.onSocialSignInSuccess()
            case .failure(let error): self.showError(error)
            }
        }
    }
    
    private func showError(_ error: Error) {
        SwiftyBeaver.error("\(error)")
        isSignInError = true
        signInError = error.localizedDescription
    }
}
