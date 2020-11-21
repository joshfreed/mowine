//
//  FacebookLoginService.swift
//  mowine
//
//  Created by Josh Freed on 3/25/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation

protocol FacebookAuthenticationService {
    func linkFacebookAccount(token: String, completion: @escaping (Result<Void, Error>) -> ())    
}
