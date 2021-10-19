//
//  UserImageStorage.swift
//  
//
//  Created by Josh Freed on 10/3/21.
//

import Foundation

public protocol UserImageStorage {
    func putImage(userId: UserId, data: Data) async throws -> URL
}
