//
//  FacebookLoginService.swift
//  mowine
//
//  Created by Josh Freed on 3/25/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import JFLib

protocol FacebookAuthenticationService {
    func signIn(completion: @escaping (EmptyResult) -> ())
}
