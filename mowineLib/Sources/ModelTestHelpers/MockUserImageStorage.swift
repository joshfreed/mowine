//
//  MockUserImageStorage.swift
//  
//
//  Created by Josh Freed on 10/3/21.
//

import Foundation
import Model

class MockUserImageStorage: UserImageStorage {
    func putImage(userId: UserId, data: Data) async throws -> URL {
        URL(string: "https://google.com")!
    }
}
