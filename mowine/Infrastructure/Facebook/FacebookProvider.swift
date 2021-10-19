//
//  FacebookProvider.swift
//  mowine
//
//  Created by Josh Freed on 3/23/19.
//  Copyright © 2019 Josh Freed. All rights reserved.
//

import Foundation
import SwiftyBeaver
import Model
import MoWine_Domain

enum CreateUserFromFacebookInfoError: Error {
    case missingEmail
    case missingFirstName
}

class FacebookProvider: SocialSignInProvider {
    let fbGraphApi: GraphApi
    
    init(fbGraphApi: GraphApi) {
        self.fbGraphApi = fbGraphApi
    }

    func getNewUserInfo() async throws -> NewUserInfo {
        return try await withCheckedThrowingContinuation { cont in
            getNewUserInfo()  { res in
                cont.resume(with: res)
            }
        }
    }

    private func getNewUserInfo(completion: @escaping (Result<NewUserInfo, Error>) -> ()) {
        fbGraphApi.me(params: ["fields": "email,first_name,last_name"]) { result in
            switch result {
            case .success(let fields): self.createNewUserFromFacebookFields(fields, completion: completion)
            case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    func createNewUserFromFacebookFields(_ fields: [String: Any], completion: @escaping (Result<NewUserInfo, Error>) -> ()) {
        guard let email = fields["email"] as? String else {
            completion(.failure(CreateUserFromFacebookInfoError.missingEmail))
            return
        }
        guard let firstName = fields["first_name"] as? String else {
            completion(.failure(CreateUserFromFacebookInfoError.missingFirstName))
            return
        }
        let lastName = fields["last_name"] as? String
        let newUserInfo = NewUserInfo(email: email, firstName: firstName, lastName: lastName)
        completion(.success(newUserInfo))
    }
    
    func getProfilePictureUrl(_ urlString: String) -> String {
        urlString + "?width=400"
    }
}
