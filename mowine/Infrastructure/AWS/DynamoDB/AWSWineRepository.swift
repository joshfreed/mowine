//
//  AWSWineRepository.swift
//  mowine
//
//  Created by Josh Freed on 4/9/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import JFLib
import AWSDynamoDB
import AWSMobileClient

class AWSWineRepository: WineRepository {
    let dynamoDbObjectMapper: AWSDynamoDBObjectMapper
    
    init(dynamoDbObjectMapper: AWSDynamoDBObjectMapper) {
        self.dynamoDbObjectMapper = dynamoDbObjectMapper
    }
    
    func add(_ wine: Wine, completion: @escaping (Result<Wine>) -> ()) {
        
    }

    func save(_ wine: Wine, completion: @escaping (Result<Wine>) -> ()) {
        let awsWine = wine.toAWSWine()
        awsWine._userId = AWSIdentityManager.default().identityId

        dynamoDbObjectMapper.save(awsWine) { error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(wine))
                }
            }
        }
    }
    
    func delete(_ wine: Wine, completion: @escaping (EmptyResult) -> ()) {
        let awsWine = wine.toAWSWine()
        awsWine._userId = AWSIdentityManager.default().identityId
        
        dynamoDbObjectMapper.remove(awsWine) { error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success)
                }
            }
        }
    }
    
    func getWines(userId: UserId, completion: @escaping (Result<[Wine]>) -> ()) {
        let queryExpression = AWSDynamoDBQueryExpression()
        queryExpression.keyConditionExpression = "#userId = :userId"
        queryExpression.expressionAttributeNames = ["#userId": "userId"]
        queryExpression.expressionAttributeValues = [":userId": userId.asString]
        
        dynamoDbObjectMapper.query(AWSWine.self, expression: queryExpression) { response, error in
            DispatchQueue.main.async {
                if let error = error as NSError? {
                    completion(.failure(error))
                } else if let response = response, let items = response.items as? [AWSWine] {
                    let wines: [Wine] = items.compactMap { Wine.fromAWSWine($0) }
                    completion(.success(wines))
                } else {
                    completion(.success([]))
                }
            }
        }
    }
    
    func getWines(userId: UserId, wineType: WineType, completion: @escaping (Result<[Wine]>) -> ()) {
        getWines(userId: userId) { result in
            switch result {
            case .success(let wines):
                let filteredWines = wines.filter { $0.type.name == wineType.name }
                completion(.success(filteredWines))
            case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    func getTopWines(userId: UserId, completion: @escaping (Result<[Wine]>) -> ()) {
        let queryExpression = AWSDynamoDBQueryExpression()
        queryExpression.keyConditionExpression = "#userId = :userId"
        queryExpression.expressionAttributeNames = ["#userId": "userId"]
        queryExpression.expressionAttributeValues = [":userId": userId.asString]
        
        dynamoDbObjectMapper.query(AWSWine.self, expression: queryExpression) { response, error in
            DispatchQueue.main.async {
                if let error = error as NSError? {
                    completion(.failure(error))
                } else if let response = response, let items = response.items as? [AWSWine] {
                    let slice = items
                        .compactMap({ Wine.fromAWSWine($0) })
                        .sorted(by: { $0.rating > $1.rating })
                        .prefix(3)
                    let wines: [Wine] = Array(slice)
                    completion(.success(wines))
                } else {
                    completion(.success([]))
                }
            }
        }
    }
}
