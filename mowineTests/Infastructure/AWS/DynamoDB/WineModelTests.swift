//
//  AWSWine.swift
//  mowineTests
//
//  Created by Josh Freed on 4/9/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import XCTest
@testable import mowine
import Nimble
import AWSDynamoDB

class WineModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: Model to AWSWine
    
    func testWineToAWSWine() {
        let id = UUID()
        let type = WineType(name: "Red", varieties: [])
        let variety = WineVariety(name: "Merlot")
        let wine = Wine(id: id, type: type, name: "Some Great Wine", rating: 4)
        wine.variety = variety
        wine.location = "Wegman's"
        wine.notes = "These are notes about this wine"
        wine.price = "$33.50"
        
        let result = wine.toAWSWine()
        
        expect(result._wineId).to(equal(id.uuidString))
        expect(result._name).to(equal("Some Great Wine"))
        expect(result._rating).to(equal(4))
        expect(result._type).to(equal("Red"))
        expect(result._variety).to(equal("Merlot"))
        expect(result._location).to(equal("Wegman's"))
        expect(result._notes).to(equal("These are notes about this wine"))
        expect(result._price).to(equal("$33.50"))
    }
    
    func testWineToAWSWine_no_variety() {
        let wine = WineBuilder.aWine().build()
        let result = wine.toAWSWine()
        expect(result._variety).to(beNil())
    }
    
    func testWineToAWSWine_pairings() {
        let wine = WineBuilder.aWine().pairedWith(["Sushi", "Cheese"]).build()
        
        let result = wine.toAWSWine()
        
        expect(result._pairings).to(haveCount(2))
        expect(result._pairings).to(contain("Sushi", "Cheese"))
    }
    
    func testWineToAWSWine_empty_pairings_becomes_nil() {
        let wine = WineBuilder.aWine().pairedWith([]).build()
        
        let result = wine.toAWSWine()
        
        expect(result._pairings).to(beNil())
    }
    
    func testWineToAWSWine_createdAt_converted_to_iso8601_format() {
        let createdAt = Date.makeDate(from: "2018-04-09 14:30:00")!
        let expected = ISO8601DateFormatter().string(from: createdAt)
        let wine = WineBuilder.aWine().build()
        wine.createdAt = createdAt
        
        let result = wine.toAWSWine()
        
        expect(result._createdAt).to(equal(expected))
    }

    // MARK: AWSWine to Model
    
    func test_fromAWSWine() {
        let wineId = UUID()
        let awsWine: AWSWine = AWSWine()
        awsWine._wineId = wineId.uuidString
        awsWine._name = "My Great Wine"
        awsWine._rating = 2
        awsWine._type = "White"
        
        let wine = Wine.fromAWSWine(awsWine)
        
        expect(wine).toNot(beNil())
        expect(wine?.id).to(equal(wineId))
        expect(wine?.name).to(equal("My Great Wine"))
        expect(wine?.rating).to(equal(2))
        expect(wine?.type).to(equal(WineType(name: "White", varieties: [])))
        expect(wine?.variety).to(beNil())
        expect(wine?.location).to(beNil())
        expect(wine?.notes).to(beNil())
        expect(wine?.price).to(beNil())
    }
    
    func test_fromAWSWine_id_required() {
        let awsWine: AWSWine = AWSWine()
        //awsWine._wineId = wineId.uuidString
        awsWine._name = "My Great Wine"
        awsWine._rating = 2
        awsWine._type = "White"
        
        let wine = Wine.fromAWSWine(awsWine)
        
        expect(wine).to(beNil())
    }
    
    func test_fromAWSWine_name_required() {
        let wineId = UUID()
        let awsWine: AWSWine = AWSWine()
        awsWine._wineId = wineId.uuidString
        //awsWine._name = "My Great Wine"
        awsWine._rating = 2
        awsWine._type = "White"
        
        let wine = Wine.fromAWSWine(awsWine)
        
        expect(wine).to(beNil())
    }
    
    func test_fromAWSWine_rating_required() {
        let wineId = UUID()
        let awsWine: AWSWine = AWSWine()
        awsWine._wineId = wineId.uuidString
        awsWine._name = "My Great Wine"
        //awsWine._rating = 2
        awsWine._type = "White"
        
        let wine = Wine.fromAWSWine(awsWine)
        
        expect(wine).to(beNil())
    }
    
    func test_fromAWSWine_type_required() {
        let wineId = UUID()
        let awsWine: AWSWine = AWSWine()
        awsWine._wineId = wineId.uuidString
        awsWine._name = "My Great Wine"
        awsWine._rating = 2
        //awsWine._type = "White"
        
        let wine = Wine.fromAWSWine(awsWine)
        
        expect(wine).to(beNil())
    }
    
    func test_fromAWSWine_translates_variety() {
        let awsWine = anAWSWine()
        awsWine._variety = "Whatever"
        
        let wine = Wine.fromAWSWine(awsWine)
        
        expect(wine?.variety).to(equal(WineVariety(name: "Whatever")))
    }
    
    func test_fromAWSWine_extra_attributes() {
        let awsWine = anAWSWine()
        awsWine._location = "Wegman's"
        awsWine._notes = "This is a note"
        awsWine._price = "$44"
        
        let wine = Wine.fromAWSWine(awsWine)
        
        expect(wine?.location).to(equal("Wegman's"))
        expect(wine?.notes).to(equal("This is a note"))
        expect(wine?.price).to(equal("$44"))
    }
    
    func test_fromAWSWine_translates_pairings() {
        let awsWine = anAWSWine()
        awsWine._pairings = Set<String>()
        awsWine._pairings?.insert("Sushi")
        awsWine._pairings?.insert("Pizza")

        let wine = Wine.fromAWSWine(awsWine)
        
        expect(wine?.pairings).to(haveCount(2))
        expect(wine?.pairings).to(contain("Sushi", "Pizza"))
    }
    
    func test_fromAWSWine_converts_createdAt() {
        let awsWine = anAWSWine()
        awsWine._createdAt = "2018-04-09T18:30:00Z"
        let expected = ISO8601DateFormatter().date(from: "2018-04-09T18:30:00Z")
        
        let wine = Wine.fromAWSWine(awsWine)
        
        expect(wine?.createdAt).to(equal(expected))
    }
    
    // MARK: Helpers
    
    private func anAWSWine() -> AWSWine {
        let wineId = UUID()
        let awsWine: AWSWine = AWSWine()
        awsWine._wineId = wineId.uuidString
        awsWine._name = "My Great Wine"
        awsWine._rating = 2
        awsWine._type = "White"
        return awsWine
    }
}
