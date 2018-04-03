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

    func searchUsers(searchString: String, completion: @escaping (Result<[User]>) -> ()) {
        let scanExpression = AWSDynamoDBScanExpression()
        
        dynamoDbObjectMapper.scan(AWSUser.self, expression: scanExpression) { (response: AWSDynamoDBPaginatedOutput?, error: Error?) in
            DispatchQueue.main.async(execute: {
                
                if let error = error as NSError? {
                    completion(.failure(error))
                } else if let response = response {
                    if let items = response.items as? [AWSUser] {
                        let users: [User] = items.compactMap { User.fromAWSUser($0) }
                        let matches = self.filterUsers(searchString: searchString, allUsers: users)
                        completion(.success(matches))
                    } else {
                        completion(.success([]))
                    }
                } else {
                    completion(.success([]))
                }
                
            })
        }
    }
    
    private func filterUsers(searchString: String, allUsers: [User]) -> [User] {
        let words = searchString.lowercased().split(separator: " ")
        var matches: [User] = []
        
        for word in words {
            let m = allUsers.filter {
                let firstName = ($0.firstName ?? "").lowercased()
                let lastName = ($0.lastName ?? "").lowercased()
                return firstName.starts(with: word) || lastName.starts(with: word)
            }
            matches.append(contentsOf: m)
        }
        
        return matches
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
    
    // MARK: - Friends
    
    func getFriendsOf(userId: UserId, completion: @escaping (Result<[User]>) -> ()) {
        let scanExpression = AWSDynamoDBScanExpression()
        scanExpression.filterExpression = "#userId = :userId"
        scanExpression.expressionAttributeNames = ["#userId": "userId"]
        scanExpression.expressionAttributeValues = [":userId": userId.asString]
        
        dynamoDbObjectMapper.scan(AWSFriend.self, expression: scanExpression) { (response: AWSDynamoDBPaginatedOutput?, error: Error?) in
            DispatchQueue.main.async {
                if let error = error as NSError? {
                    completion(.failure(error))
                } else if let response = response {
                    if let items = response.items as? [AWSFriend] {
                        let userIds = items
                            .compactMap({ $0._friendId })
                            .map({ UserId(string: $0) })
                        self.loadUsersFor(ids: userIds, completion: completion)
                    } else {
                        completion(.success([]))
                    }
                } else {
                    completion(.success([]))
                }
            }
        }
    }
    
    private func loadUsersFor(ids: [UserId], completion: @escaping (Result<[User]>) -> ()) {
        var users: [User] = []
        let group = DispatchGroup()
        
        for id in ids {
            group.enter()
            getUserById(id) { result in
                switch result {
                case .success(let user):
                    if let user = user {
                        users.append(user)
                    }
                case .failure: break
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(.success(users))
        }
    }
    
    func isFriendOf(userId: UserId, otherUserId: UserId, completion: @escaping (Result<Bool>) -> ()) {        
        dynamoDbObjectMapper.load(AWSFriend.self, hashKey: userId.asString, rangeKey: otherUserId.asString) { (objectModel: AWSDynamoDBObjectModel?, error: Error?) in
            DispatchQueue.main.async {
                if let error = error {
                    print("Amazon DynamoDB Read Error: \(error)")
                    completion(.failure(error))
                } else if let _ = objectModel as? AWSFriend {
                    completion(.success(true))
                } else {
                    completion(.success(false))
                }
            }
        }
    }
    
    func addFriend(owningUserId: UserId, friendId: UserId, completion: @escaping (Result<User>) -> ()) {
        let friendship: AWSFriend = AWSFriend()
        friendship._userId = owningUserId.asString
        friendship._friendId = friendId.asString
        
        dynamoDbObjectMapper.save(friendship) { (error: Error?) in
            DispatchQueue.main.async {
                if let error = error {
                    print("Amazon DynamoDB Save Error: \(error)")
                    completion(.failure(error))
                } else {
                    self.getUserById(friendId) { result in
                        switch result {
                        case .success(let newFriend):
                            if let newFriend = newFriend {
                                completion(.success(newFriend))
                            } else {
                                print("Couldn't load friend with id \(friendId)")
                                completion(.failure(MoWineError.unknownError))
                            }
                        case .failure(let error): completion(.failure(error))
                        }
                    }
                }
            }
        }
    }
    
    func removeFriend(owningUserId: UserId, friendId: UserId, completion: @escaping (EmptyResult) -> ()) {
        let friendship: AWSFriend = AWSFriend()
        friendship._userId = owningUserId.asString
        friendship._friendId = friendId.asString
        
        dynamoDbObjectMapper.remove(friendship) { (error: Error?) in
            DispatchQueue.main.async {
                if let error = error {
                    print("Amazon DynamoDB Save Error: \(error)")
                    completion(.failure(error))
                } else {
                    completion(.success)
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
