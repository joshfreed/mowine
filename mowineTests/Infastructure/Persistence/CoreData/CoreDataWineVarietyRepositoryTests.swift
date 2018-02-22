//
//  CoreDataWineVarietyRepositoryTests.swift
//  mowineTests
//
//  Created by Josh Freed on 2/22/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import XCTest
@testable import mowine
import CoreData
import Nimble

class CoreDataWineVarietyRepositoryTests: XCTestCase {
    var sut: CoreDataWineVarietyRepository!
    let coreData = CoreDataHelper()
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        coreData.setUp()
        sut = CoreDataWineVarietyRepository(container: coreData.container)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: Get variety by name
    
    func testGetVarietyByName() {
        // Given
        coreData.insert(WineVariety(name: "Malbec"))
        coreData.insert(WineVariety(name: "Pino Grigio"))
        coreData.insert(WineVariety(name: "Merlot"))
        var actual: WineVariety?
        
        // When
        sut.getVariety(named: "Merlot") { result in
            if case let .success(found) = result {
                actual = found
            }
        }
        
        // Then
        expect(actual).toNot(beNil())
        expect(actual?.name).to(equal("Merlot"))
    }
    
    func testGetVarietyByName_notFound() {
        // Given
        coreData.insert(WineVariety(name: "Malbec"))
        coreData.insert(WineVariety(name: "Pino Grigio"))
        coreData.insert(WineVariety(name: "Merlot"))
        var error: Error?
        
        // When
        sut.getVariety(named: "CHUMBA WUMBA") { result in
            if case let .failure(e) = result {
                error = e
            }
        }
        
        // Then
        expect(error).toNot(beNil())
        expect(error).to(matchError(WineVarietyRepositoryError.notFound))
    }
}
