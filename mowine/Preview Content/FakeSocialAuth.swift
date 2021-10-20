//
//  FakeSocialAuthService.swift
//  mowine
//
//  Created by Josh Freed on 1/11/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation
import MoWine_Application
import MoWine_Domain

class FakeSocialAuth: SocialAuthService {
    func signIn(with token: SocialToken) async throws {}
    
    func reauthenticate(with token: SocialToken) async throws {}
}
