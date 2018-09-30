//
//  DynamoDbWorker.swift
//  mowine
//
//  Created by Josh Freed on 9/30/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import AWSDynamoDB
import JFLib

protocol DynamoConvertible {
    associatedtype AWSType: AWSDynamoDBObjectModel
    static func toEntity(awsObject: AWSType) -> Self?
    func toDynamoDb() -> AWSType?
}

protocol DynamoDbWorkerProtocol {
    func scan<Entity: DynamoConvertible>(completion: @escaping (Result<[Entity]>) -> Void)
}

class DynamoDbWorker: DynamoDbWorkerProtocol {
    let dynamoDbObjectMapper: AWSDynamoDBObjectMapper
    
    init(dynamoDbObjectMapper: AWSDynamoDBObjectMapper) {
        self.dynamoDbObjectMapper = dynamoDbObjectMapper
    }
    
    func scan<Entity: DynamoConvertible>(completion: @escaping (Result<[Entity]>) -> Void) {
        let scanExpression = AWSDynamoDBScanExpression()
        
        dynamoDbObjectMapper.scan(Entity.AWSType.self, expression: scanExpression) { response, error in
            DispatchQueue.main.async {
                if let error = error as NSError? {
                    completion(.failure(error))
                    return
                }
                
                let items = response?.items as? [Entity.AWSType]
                let entities: [Entity] = items?.compactMap { Entity.toEntity(awsObject: $0) } ?? []
                completion(.success(entities))
            }
        }
    }
}
