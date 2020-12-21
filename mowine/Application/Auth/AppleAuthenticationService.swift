//
//  AppleAuthenticationService.swift
//  mowine
//
//  Created by Josh Freed on 12/20/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import Foundation

protocol AppleAuthenticationService {
    func linkAppleAccount(token: AppleToken, completion: @escaping (Result<Void, Error>) -> ())   
}
