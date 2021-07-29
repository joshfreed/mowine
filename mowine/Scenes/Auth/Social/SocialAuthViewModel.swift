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
    
    func socialSignIn(type: SocialProviderType, onLogIn: @escaping () -> Void) {
        guard let method = socialSignInMethods[type] else {
            fatalError("No sign in method registered for provider: \(type)")
        }
        
        method.signIn { result in
            switch result {
            case .success(let token): self.linkToSession(type: type, token: token, onLogIn: onLogIn)
            case .failure(let error): self.showError(error)
            }
        }
    }
    
    private func linkToSession(type: SocialProviderType, token: SocialToken, onLogIn: @escaping () -> Void) {
        isSigningIn = true
        
        worker.login(type: type, token: token) { result in
            self.isSigningIn = false
            
            switch result {
            case .success:
                onLogIn()
//                NotificationCenter.default.post(name: .signedIn, object: nil)
            case .failure(let error):
                self.showError(error)
            }
        }
    }
    
    private func onSocialSignInSuccess() {
        
    }
    
    private func showError(_ error: Error) {
        SwiftyBeaver.error("\(error)")
        isSignInError = true
        signInError = error.localizedDescription
    }
}
