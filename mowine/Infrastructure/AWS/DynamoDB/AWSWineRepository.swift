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

extension Wine {
    func toAWSWine() -> AWSWine {
        let awsWine: AWSWine = AWSWine()
        awsWine._wineId = id.uuidString
        awsWine._name = name
        awsWine._rating = NSNumber(value: rating)
        awsWine._type = type.name
        awsWine._variety = variety?.name
        awsWine._location = location
        awsWine._notes = notes
        awsWine._price = price
        
        if pairings.count > 0 {
            awsWine._pairings = Set(pairings)
        }
        
        if let createdAt = createdAt {
            awsWine._createdAt = ISO8601DateFormatter().string(from: createdAt)
        }
        
        return awsWine
    }
    
    static func fromAWSWine(_ awsWine: AWSWine) -> Wine? {
        guard let wineIdStr = awsWine._wineId, let wineId = UUID(uuidString: wineIdStr) else {
            return nil
        }
        guard let name = awsWine._name else {
            return nil
        }
        guard let typeName = awsWine._type else {
            return nil
        }
        guard let rating = awsWine._rating else {
            return nil
        }
        
        let wineType = WineType(name: typeName, varieties: [])
        
        let wine = Wine(id: wineId, type: wineType, name: name, rating: rating.doubleValue)
        
        if let varietyName = awsWine._variety {
            wine.variety = WineVariety(name: varietyName)
        }

        wine.location = awsWine._location
        wine.notes = awsWine._notes
        wine.price = awsWine._price
        wine.pairings = Array(awsWine._pairings ?? [])
        
        if let createdAt = awsWine._createdAt {
            wine.createdAt = ISO8601DateFormatter().date(from: createdAt)
        }
        
        return wine
    }
}
