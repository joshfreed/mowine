//
//  SocialSignIn.swift
//  mowine
//
//  Created by Josh Freed on 12/20/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import Foundation

public struct NewUserInfo {
    public var email: String
    public var firstName: String
    public var lastName: String?

    public init(email: String, firstName: String, lastName: String? = nil) {
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
    }
}

public enum SocialProviderType {
    case apple
    case facebook
    case google
}

public protocol SocialToken {}

public protocol SocialSignInProvider {
    func getNewUserInfo(completion: @escaping (Result<NewUserInfo, Error>) -> ())
    func getProfilePictureUrl(_ urlString: String) -> String
}

public protocol SocialSignInMethod {
    func signIn(completion: @escaping (Result<SocialToken, Error>) -> Void)
}

public protocol SocialAuthService {
    func signIn(with token: SocialToken, completion: @escaping (Result<Void, Error>) -> ())
    func reauthenticate(with token: SocialToken, completion: @escaping (Result<Void, Error>) -> ())
}
