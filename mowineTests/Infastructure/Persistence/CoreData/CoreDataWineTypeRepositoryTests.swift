//
//  CoreDataWineTypeRepositoryTests.swift
//  mowineTests
//
//  Created by Josh Freed on 2/21/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import XCTest
@testable import mowine
import Nimble
import CoreData

class CoreDataWineTypeRepositoryTests: XCTestCase {
    var sut: CoreDataWineTypeRepository!
    let coreData = CoreDataHelper()
    var red: WineType!
    var white: WineType!
    var bubbly: WineType!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        coreData.setUp()
        sut = CoreDataWineTypeRepository(container: coreData.container)
        
        red = WineType(name: "Red", varieties: [
            WineVariety(name: "Merlot")
        ])
        white = WineType(name: "White", varieties: [
            WineVariety(name: "Chardonnay"),
            WineVariety(name: "Sauvignon Blanc")
        ])
        bubbly = WineType(name: "Bubbly", varieties: [
            WineVariety(name: "Prosecco")
        ])
        coreData.insert(red)
        coreData.insert(white)
        coreData.insert(bubbly)
        coreData.save()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: Get all
    
    func test_getAll() {
        // Given
        let completionExpectation = expectation(description: "operation complete")
        
        // When
        var wineTypes: [WineType] = []
        sut.getAll() { result in
            if case let .success(types) = result {
                wineTypes = types
                completionExpectation.fulfill()
            } else {
                fail("Operation failed")
            }
        }
        
        // Then
        wait(for: [completionExpectation], timeout: 3)
        expect(wineTypes).to(haveCount(3))
        expect(wineTypes).to(contain(red))
        expect(wineTypes).to(contain(white))
        expect(wineTypes).to(contain(bubbly))
        expect(wineTypes[0].varieties.count).to(beGreaterThan(0))
    }
    
    // MARK: Get one by name
    
    func test_getOneByName() {
        // Given
        let completionExpectation = expectation(description: "operation complete")
        var actual: WineType?
        
        // When
        sut.getWineType(named: "White") { result in
            if case let .success(type) = result {
                actual = type
                completionExpectation.fulfill()
            } else {
                fail("Operation failed")
            }
        }
        
        // Given
        wait(for: [completionExpectation], timeout: 3)
        expect(actual?.name).to(equal("White"))
        expect(actual?.varieties).to(haveCount(white.varieties.count))
        expect(actual?.varieties).to(contain(white.varieties))
    }
}
