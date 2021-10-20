//
//  FirebaseCredentialFactory.swift
//  mowine
//
//  Created by Josh Freed on 12/21/20.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import FirebaseAuth
import MoWine_Application
import MoWine_Domain

class FirebaseCredentialMegaFactory {
    func makeCredential(from token: SocialToken) -> AuthCredential {
        if let token = token as? AppleToken {
            return AppleCredentialFactory().makeCredential(from: token)
        } else if let token = token as? FacebookToken {
            return FacebookCredentialFactory().makeCredential(from: token)
        } else if let token = token as? GoogleToken {
            return GoogleCredentialFactory().makeCredential(from: token)
        } else {
            fatalError("Invalid token type: \(token)")
        }
    }
}

protocol FirebaseCredentialFactory {
    associatedtype Token: SocialToken
    func makeCredential(from token: Token) -> AuthCredential
}

class AppleCredentialFactory: FirebaseCredentialFactory {
    func makeCredential(from token: AppleToken) -> AuthCredential {
        OAuthProvider.credential(withProviderID: "apple.com", idToken: token.idTokenString, rawNonce: token.nonce)
    }
}

class FacebookCredentialFactory: FirebaseCredentialFactory {
    func makeCredential(from token: FacebookToken) -> AuthCredential {
        FacebookAuthProvider.credential(withAccessToken: token.token)
    }
}

class GoogleCredentialFactory: FirebaseCredentialFactory {
    func makeCredential(from token: GoogleToken) -> AuthCredential {
        GoogleAuthProvider.credential(withIDToken: token.idToken, accessToken: token.accessToken)
    }
}
