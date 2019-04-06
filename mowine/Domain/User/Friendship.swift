//
//  Friend.swift
//  mowine
//
//  Created by Josh Freed on 11/3/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation

struct Friendship: Equatable {
    let id: String
    let userId: UserId
    let friendId: UserId
    
    init(id: String, userId: UserId, friendId: UserId) {
        self.id = id
        self.userId = userId
        self.friendId = friendId
    }
    
    init(userId: UserId, friendId: UserId) {
        id = UUID().uuidString
        self.userId = userId
        self.friendId = friendId
    }
    
    static func ==(lhs: Friendship, rhs: Friendship) -> Bool {
        return lhs.userId == rhs.userId && lhs.friendId == rhs.friendId
    }
}
