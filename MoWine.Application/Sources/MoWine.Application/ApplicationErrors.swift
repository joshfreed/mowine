//
//  ApplicationErrors.swift
//  
//
//  Created by Josh Freed on 10/3/21.
//

import Foundation

public enum MoWineError: Error {
    case error(message: String)
    case unknownError
    case notLoggedIn
    case dictionaryError(message: String)
}

public enum ApplicationErrors: Error {
    case userNotFound
    case wineTypeNotFound
}
