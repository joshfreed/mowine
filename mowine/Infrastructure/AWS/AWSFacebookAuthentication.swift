//
//  AWSFacebookLogin.swift
//  mowine
//
//  Created by Josh Freed on 3/25/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import JFLib
import AWSAuthCore
import AWSFacebookSignIn
import FBSDKLoginKit

class AWSFacebookAuthentication: FacebookAuthenticationService {
    lazy var providerKey = AWSFacebookSignInProvider.sharedInstance().identityProviderName
    
    func signIn(completion: @escaping (EmptyResult) -> ()) {
        AWSFacebookSignInProvider.sharedInstance().setLoginBehavior(FBSDKLoginBehavior.native.rawValue)
        
        AWSSignInManager.sharedInstance().login(signInProviderKey: providerKey) { (result: Any?, error: Error?) in

            DispatchQueue.main.async {
                if let e = error {
                    print("Facebook Sign In Failed")
                    let error = e as NSError
                    print("\(error)")
                    completion(.failure(error))
                } else {
                    print("Facebook Sign In Success")
                    let identityId = (Container.shared.session as! AWSSession).identityId
                    print("Identity id \(String(describing: identityId))")
                    completion(.success)
                }
            }
            
        }
    }
}
