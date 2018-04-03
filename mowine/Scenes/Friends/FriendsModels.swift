//
//  FriendsModels.swift
//  mowine
//
//  Created by Josh Freed on 3/6/18.
//  Copyright (c) 2018 Josh Freed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum Friends {
    struct DisplayedUser {
        let userId: String
        var fullName: String
        var profilePicture: UIImage
        var isFriend: Bool = false
        
        init(userId: String, fullName: String) {
            self.userId = userId
            self.fullName = fullName
            profilePicture = #imageLiteral(resourceName: "No Profile Picture")
        }
    }
    
    // MARK: Use cases

    enum FetchFriends {
        struct Request {
        }

        struct Response {
            var friends: [User]
        }

        struct ViewModel {
            var friends: [DisplayedUser]
        }
    }
    
    enum SearchUsers {
        struct Request {
            var searchString: String
        }
        
        struct Response {
            var matches: [User]
            var myFriends: [User]
        }
        
        struct ViewModel {
            var matches: [DisplayedUser]
        }
    }    
    
    enum AddFriend {
        struct Request {
            var userId: String
        }
        
        struct Response {
            var userId: String
        }
        
        struct ViewModel {
            var userId: String
        }
    }
    
    enum SelectUser {
        struct Request {
            var userId: String
        }
        
        struct Response {            
        }
        
        struct ViewModel {
        }
    }
}
