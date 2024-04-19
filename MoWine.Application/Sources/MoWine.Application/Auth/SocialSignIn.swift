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

/// Retrieves user data from a social platform
public protocol SocialSignInProvider {
    func getNewUserInfo() async throws -> NewUserInfo
    func getProfilePictureUrl(_ urlString: String) -> String
}

/// Generates an auth token from a 3rd party social sign in services
public protocol SocialSignInMethod {
    func signIn() async throws -> SocialToken
}

/// Performs authentication related actions for a specific social sign in platform
public protocol SocialAuthService {
    func signIn(with token: SocialToken) async throws
    func reauthenticate(with token: SocialToken) async throws
}

public enum SocialSignInErrors: Error {
    case googleUserNotFound
    case missingIdToken
    case signInCancelled
}
