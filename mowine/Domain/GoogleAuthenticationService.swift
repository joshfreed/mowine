//
//  GoogleAuthenticationService.swift
//  mowine
//
//  Created by Josh Freed on 12/22/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import JFLib

protocol GoogleAuthenticationService {
    func linkGoogleAccount(idToken: String, accessToken: String, completion: @escaping (EmptyResult) -> ())
}
