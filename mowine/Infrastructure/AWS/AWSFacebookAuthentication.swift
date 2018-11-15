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
import AWSUserPoolsSignIn
import FBSDKLoginKit

//
// DEPRECATED
// Not used any more, using AWSMobileAuth instead
//

class AWSFacebookAuthentication: FacebookAuthenticationService {
    lazy var providerKey = AWSFacebookSignInProvider.sharedInstance().identityProviderName
    
    func linkFacebookAccount(token: String, completion: @escaping (EmptyResult) -> ()) {
        AWSFacebookSignInProvider.sharedInstance().setLoginBehavior(FBSDKLoginBehavior.native.rawValue)
        
        AWSSignInManager.sharedInstance().login(signInProviderKey: providerKey) { (result: Any?, error: Error?) in
            let awsResult = AWSResult(result: result, error: error)
            
            DispatchQueue.main.async {
                if awsResult.isError {
                    completion(.failure(awsResult.error!))
                } else {
                    completion(.success)
                }
            }
        }
    }
}
