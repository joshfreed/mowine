//
//  SocialSignIn.swift
//  mowine
//
//  Created by Josh Freed on 12/20/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import Foundation

struct NewUserInfo {
    var email: String
    var firstName: String
    var lastName: String?
}

enum LoginType {
    case email
    case social(SocialProviderType)
}

enum SocialProviderType {
    case apple
    case facebook
    case google
}

protocol SocialToken {}

protocol SocialSignInProvider {
    associatedtype Token: SocialToken
    func linkAccount(token: Token, completion: @escaping (Result<Void, Error>) -> ())
    func getNewUserInfo(completion: @escaping (Result<NewUserInfo, Error>) -> ())
    func getProfilePictureUrl(_ urlString: String) -> String
}

protocol SocialSignInMethod {
    func signIn(completion: @escaping (Result<SocialToken, Error>) -> Void)
}

protocol AllSocialSignInWorker {
    func login(token: SocialToken, completion: @escaping (Result<User, Error>) -> ())
}
