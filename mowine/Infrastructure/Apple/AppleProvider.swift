//
//  AppleProvider.swift
//  mowine
//
//  Created by Josh Freed on 12/20/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import Foundation
import FirebaseAuth
import SwiftyBeaver
import MoWine_Application
import MoWine_Domain

class AppleProvider: SocialSignInProvider {
    func getNewUserInfo() async throws -> NewUserInfo {
        if let currentUser = Auth.auth().currentUser, let email = currentUser.email {
            let newUserInfo = NewUserInfo(email: email, firstName: currentUser.displayName ?? "")
            return newUserInfo
        } else {
            SwiftyBeaver.warning("No current user or email address")
            throw MoWineError.error(message: "No current user or email address")
        }
    }
    
    func getProfilePictureUrl(_ urlString: String) -> String {
        urlString
    }
}
