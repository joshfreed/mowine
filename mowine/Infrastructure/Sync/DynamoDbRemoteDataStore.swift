//
//  DynamoDbRemoteDataStore.swift
//  mowine
//
//  Created by Josh Freed on 9/30/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import JFLib
import AWSDynamoDB

class DynamoDbRemoteDataStore<Entity>: RemoteDataStore where Entity: DynamoConvertible {
    let dynamoDbWorker: DynamoDbWorkerProtocol
    
    init(dynamoDbWorker: DynamoDbWorkerProtocol) {
        self.dynamoDbWorker = dynamoDbWorker
    }
    
    func fetchAll(completion: @escaping (Result<[Entity]>) -> ()) {
        dynamoDbWorker.scan(completion: completion)
    }
}
