//
//  FakeSocialAuthService.swift
//  mowine
//
//  Created by Josh Freed on 1/11/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation
import Model

class FakeSocialAuth: SocialAuthService {
    func signIn(with token: SocialToken, completion: @escaping (Result<Void, Error>) -> ()) {
        completion(.success(()))
    }
    
    func reauthenticate(with token: SocialToken, completion: @escaping (Result<Void, Error>) -> ()) {
        completion(.success(()))
    }
}
