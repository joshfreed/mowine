//
//  DynamoDbService.swift
//  mowine
//
//  Created by Josh Freed on 9/20/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import AWSDynamoDB
import AWSMobileClient
import JFLib

class DynamoDbService {
    let dynamoDbObjectMapper: AWSDynamoDBObjectMapper
    
    init(dynamoDbObjectMapper: AWSDynamoDBObjectMapper) {
        self.dynamoDbObjectMapper = dynamoDbObjectMapper
    }
    
    func scanUsers(completion: @escaping (Result<[User]>) -> ()) {
        let expression = AWSDynamoDBScanExpression()
        dynamoDbObjectMapper.scan(AWSUser.self, expression: expression) { response, error in
            DispatchQueue.main.async(execute: {
                if let error = error as NSError? {
                    completion(.failure(error))
                } else if let response = response {
                    if let items = response.items as? [AWSUser] {
                        let users: [User] = items.compactMap { User.fromAWSUser($0) }
                        completion(.success(users))
                    } else {
                        completion(.success([]))
                    }
                } else {
                    completion(.success([]))
                }
            })
        }
    }
    
    /*
    func scanWines(completion: @escaping (Result<[Wine]>) -> ()) {
        let expression = AWSDynamoDBScanExpression()
        dynamoDbObjectMapper.scan(AWSWine.self, expression: expression) { response, error in
            DispatchQueue.main.async(execute: {
                if let error = error as NSError? {
                    completion(.failure(error))
                } else if let response = response {
                    if let items = response.items as? [AWSWine] {
                        let wines: [Wine] = items.compactMap { Wine.fromAWSWine($0) }
                        completion(.success(wines))
                    } else {
                        completion(.success([]))
                    }
                } else {
                    completion(.success([]))
                }
            })
        }
    }
 */
/*
    func saveWine(_ wine: Wine, completion: ((EmptyResult) -> ())?) {
        let awsWine = wine.toAWSWine()
        awsWine._userId = AWSIdentityManager.default().identityId
        
        dynamoDbObjectMapper.save(awsWine) { error in
            DispatchQueue.main.async {
                if let error = error {
                    completion?(.failure(error))
                } else {
                    completion?(.success)
                }
            }
        }
    }
    
    func deleteWine(_ wine: Wine, completion: ((EmptyResult) -> ())?) {
        let awsWine = wine.toAWSWine()
        awsWine._userId = AWSIdentityManager.default().identityId
        
        dynamoDbObjectMapper.remove(awsWine) { error in
            DispatchQueue.main.async {
                if let error = error {
                    completion?(.failure(error))
                } else {
                    completion?(.success)
                }
            }
        }
    }
 */
}
