//
//  Wine.swift
//  MySampleApp
//
//
// Copyright 2018 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to 
// copy, distribute and modify it.
//
// Source code generated from template: aws-my-sample-app-ios-swift v0.19
//

import Foundation
import UIKit
import AWSDynamoDB

@objcMembers
class AWSWine: AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
    var _userId: String?
    var _wineId: String?
    var _createdAt: String?
    var _updatedAt: String?
    var _location: String?
    var _name: String?
    var _notes: String?
    var _pairings: Set<String>?
    var _price: String?
    var _rating: NSNumber?
    var _type: String?
    var _variety: String?
    var _thumbnail: Data?
    
    class func dynamoDBTableName() -> String {
        
        return "mowine-mobilehub-2014441500-Wine"
    }
    
    class func hashKeyAttribute() -> String {
        
        return "_userId"
    }
    
    class func rangeKeyAttribute() -> String {
        
        return "_wineId"
    }
    
    override class func jsonKeyPathsByPropertyKey() -> [AnyHashable: Any] {
        return [
            "_userId" : "userId",
            "_wineId" : "wineId",
            "_createdAt" : "createdAt",
            "_updatedAt" : "updatedAt",
            "_location" : "location",
            "_name" : "name",
            "_notes" : "notes",
            "_pairings" : "pairings",
            "_price" : "price",
            "_rating" : "rating",
            "_type" : "type",
            "_variety" : "variety",
            "_thumbnail" : "thumbnail"
        ]
    }
}