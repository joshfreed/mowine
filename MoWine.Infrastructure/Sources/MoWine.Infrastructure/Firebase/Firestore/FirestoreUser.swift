//
//  FirestoreUser.swift
//  mowine
//
//  Created by Josh Freed on 2/22/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation
import FirebaseFirestore
import MoWine_Domain

extension User {
    public static func fromFirestore(_ document: DocumentSnapshot) -> User? {
        guard
            let dataDict = document.data(),
            let emailAddress = dataDict["email"] as? String
        else {
            return nil
        }
        let userId = UserId(string: document.documentID)
        var user = User(id: userId, emailAddress: emailAddress)
        
        if let fullName = dataDict["fullName"] as? String {
            user.fullName = fullName
        } else {
            user.fullName = fullName(dataDict)
        }
        
        if let photoUrlString = dataDict["photoURL"] as? String {
            user.profilePictureUrl = URL(string: photoUrlString)
        }
        return user
    }
    
    private static func fullName(_ dataDict: [String: Any]) -> String {
        let firstName = (dataDict["firstName"] as? String) ?? ""
        let lastName = (dataDict["lastName"] as? String) ?? ""
        
        var _fullName = firstName
        if !_fullName.isEmpty {
            _fullName += " "
        }
        _fullName += lastName
        return _fullName
    }
    
    public func toFirestore() -> [String: Any] {
        var data: [String: Any] = [
            "email": emailAddress,
            "fullName": fullName
        ]
                
        if let photoURL = profilePictureUrl {
            data["photoURL"] = photoURL.absoluteString
        }
        
        return data
    }
}
