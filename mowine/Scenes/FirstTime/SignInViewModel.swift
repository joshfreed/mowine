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
    
    let worker: AllSocialSignInWorker
    let socialSignInMethods: [SocialProviderType: SocialSignInMethod] = [
        .facebook: SignInWithFacebook(),
        .google: SignInWithGoogle()
    ]
    
    init(firstTimeWorker: AllSocialSignInWorker) {
        self.worker = firstTimeWorker
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
        socialSignInMethods[type]?.signIn { result in
            switch result {
            case .success(let token): self.linkToSession(token: token)
            case .failure(let error): self.showError(error)
            }
        }
    }
    
    private func linkToSession(token: SocialToken) {
        isSigningIn = true
        
        worker.login(token: token) { result in
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
