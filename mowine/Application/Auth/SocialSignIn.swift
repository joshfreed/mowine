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

enum SocialProviderType {
    case apple
    case facebook
    case google
}

protocol SocialToken {}

protocol SocialSignInProvider {
    func getNewUserInfo(completion: @escaping (Result<NewUserInfo, Error>) -> ())
    func getProfilePictureUrl(_ urlString: String) -> String
}

protocol SocialSignInMethod {
    func signIn(completion: @escaping (Result<SocialToken, Error>) -> Void)
}

protocol SocialAuthService {
    func signIn(with token: SocialToken, completion: @escaping (Result<Void, Error>) -> ())
    func reauthenticate(with token: SocialToken, completion: @escaping (Result<Void, Error>) -> ())
}
