//
//  User.swift
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
class AWSUser: AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
    var _userId: String?
    var _email: String?
    var _firstName: String?
    var _lastName: String?
    var _updatedAt: String?
    
    class func dynamoDBTableName() -> String {

        return "mowine-mobilehub-2014441500-User"
    }
    
    class func hashKeyAttribute() -> String {

        return "_userId"
    }
    
    override class func jsonKeyPathsByPropertyKey() -> [AnyHashable: Any] {
        return [
               "_userId" : "userId",
               "_email" : "email",
               "_firstName" : "firstName",
               "_lastName" : "lastName",
               "_updatedAt" : "updatedAt",
        ]
    }
}
