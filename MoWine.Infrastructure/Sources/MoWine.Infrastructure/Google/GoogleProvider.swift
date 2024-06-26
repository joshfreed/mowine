//
//  GoogleProvider.swift
//  mowine
//
//  Created by Josh Freed on 3/23/19.
//  Copyright © 2019 Josh Freed. All rights reserved.
//

import Foundation
import GoogleSignIn
import MoWine_Application
import MoWine_Domain

enum CreateUserFromGoogleInfoError: Error {
    case failedToFetchProfile
}

public class GoogleProvider: SocialSignInProvider {
    public init() {}

    public func getNewUserInfo() async throws -> NewUserInfo {
        guard let profile = GIDSignIn.sharedInstance.currentUser?.profile else {
            throw CreateUserFromGoogleInfoError.failedToFetchProfile
        }

        let newUserInfo = NewUserInfo(email: profile.email, firstName: profile.givenName ?? "", lastName: profile.familyName)

        return newUserInfo
    }
    
    public func getProfilePictureUrl(_ urlString: String) -> String {
        urlString
    }
}
