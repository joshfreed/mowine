//
//  SignInInteractor.swift
//  mowine
//
//  Created by Josh Freed on 2/27/18.
//  Copyright (c) 2018 Josh Freed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol SignInBusinessLogic {
    func signIn(request: SignIn.SignIn.Request)
}

protocol SignInDataStore {
    
}

class SignInInteractor: SignInBusinessLogic, SignInDataStore {
    var presenter: SignInPresentationLogic?
    var worker: SignInWorker?
    
    // MARK: Sign In

    func signIn(request: SignIn.SignIn.Request) {        
        worker?.signIn(emailAddress: request.email, password: request.password) { result in
            switch result {
            case .success(let isLoggedIn):
                let response = SignIn.SignIn.Response(isLoggedIn: isLoggedIn, error: nil)
                self.presenter?.presentSignInResult(response: response)
            case .failure(let error):
                let response = SignIn.SignIn.Response(isLoggedIn: false, error: error)
                self.presenter?.presentSignInResult(response: response)
            }
        }
    }
}
