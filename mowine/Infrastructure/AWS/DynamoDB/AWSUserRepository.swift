//
//  AWSUserRepository.swift
//  mowine
//
//  Created by Josh Freed on 3/29/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import JFLib
import AWSDynamoDB
import AWSAuthCore

class AWSUserRepository: UserRepository {
    let dynamoDbObjectMapper: AWSDynamoDBObjectMapper
    
    init(dynamoDbObjectMapper: AWSDynamoDBObjectMapper) {
        self.dynamoDbObjectMapper = dynamoDbObjectMapper
    }
    
    func saveUser(user: User, completion: @escaping (Result<User>) -> ()) {
        let awsUser = user.toAWSUser()
        
        dynamoDbObjectMapper.save(awsUser) { (error: Error?) in
            DispatchQueue.main.async {
                if let error = error {
                    print("Amazon DynamoDB Save Error: \(error)")
                    completion(.failure(error))
                } else {
                    completion(.success(user))
                }
            }
        }
    }
    
    func getFriendsOf(userId: UserId, completion: @escaping (Result<[User]>) -> ()) {
        
    }
    
    func searchUsers(searchString: String, completion: @escaping (Result<[User]>) -> ()) {
        
    }
    
    func addFriend(owningUserId: UserId, friendId: UserId, completion: @escaping (Result<User>) -> ()) {
        
    }
    
    func removeFriend(owningUserId: UserId, friendId: UserId, completion: @escaping (EmptyResult) -> ()) {
        
    }
    
    func getUserById(_ id: UserId, completion: @escaping (Result<User?>) -> ()) {
        dynamoDbObjectMapper.load(AWSUser.self, hashKey: id.asString, rangeKey: nil) { (objectModel: AWSDynamoDBObjectModel?, error: Error?) in
            DispatchQueue.main.async {
                if let error = error {
                    print("Amazon DynamoDB Read Error: \(error)")
                    completion(.failure(error))
                } else if let awsUser = objectModel as? AWSUser {
                    completion(.success(User.fromAWSUser(awsUser)))
                } else {
                    completion(.success(nil))
                }
            }
        }
    }    
}

extension User {
    func toAWSUser() -> AWSUser {
        let awsUser: AWSUser = AWSUser()
        awsUser._userId = id.description
        awsUser._email = emailAddress
        awsUser._firstName = firstName
        awsUser._lastName = lastName
        return awsUser
    }
    
    static func fromAWSUser(_ awsUser: AWSUser) -> User? {
        guard let userIdStr = awsUser._userId else {
            return nil
        }
        guard let emailAddress = awsUser._email else {
            return nil
        }
        let userId = UserId(string: userIdStr)
        var user = User(id: userId, emailAddress: emailAddress)
        user.firstName = awsUser._firstName
        user.lastName = awsUser._lastName
        return user
    }
}
