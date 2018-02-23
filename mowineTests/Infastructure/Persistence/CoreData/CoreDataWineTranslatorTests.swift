//
//  CoreDataWineTranslatorTests.swift
//  mowineTests
//
//  Created by Josh Freed on 2/22/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import XCTest
@testable import mowine
import CoreData
import Nimble

class CoreDataWineTranslatorTests: XCTestCase {
    var sut: CoreDataWineTranslator!
    let coreData = CoreDataHelper()
    
    override func setUp() {
        super.setUp()
        coreData.setUp()
        sut = CoreDataWineTranslator(context: coreData.context)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: Map core data to domain model
    
    func testCreateWineModelFromCoreDataEntity() {
        // Given
        let wineId = UUID()
        let photo = Data(repeating: 77, count: 10)
        let thumbnail = Data(repeating: 77, count: 2)
        let type = ManagedWineType(context: coreData.context)
        type.name = "My Wine Type"
        let variety = ManagedWineVariety(context: coreData.context)
        variety.name = "Buttsex"
        let managedWine = ManagedWine(context: coreData.context)
        managedWine.wineId = wineId
        managedWine.type = type
        managedWine.variety = variety
        managedWine.name = "My Cool Wine"
        managedWine.rating = 3
        managedWine.location = "Wine and Spirits"
        managedWine.price = 46.77
        managedWine.notes = "This is a note about the wine"
        managedWine.image = photo
        managedWine.thumbnail = thumbnail
        let food1 = ManagedFood(context: coreData.context)
        food1.name = "Sushi"
        let food2 = ManagedFood(context: coreData.context)
        food2.name = "Pasta"
        managedWine.addToPairings(food1)
        managedWine.addToPairings(food2)
        
        // When
        let mapped = sut.map(from: managedWine)
        
        // Then
        expect(mapped).toNot(beNil())
        expect(mapped?.id).to(equal(wineId))
        expect(mapped?.name).to(equal("My Cool Wine"))
        expect(mapped?.rating).to(equal(3))
        expect(mapped?.type.name).to(equal("My Wine Type"))
        expect(mapped?.variety).to(equal(WineVariety(name: "Buttsex")))
        expect(mapped?.location).to(equal("Wine and Spirits"))
        expect(mapped?.price).to(beCloseTo(46.77))
        expect(mapped?.notes).to(equal("This is a note about the wine"))
        expect(mapped?.photo).to(equal(photo))
        expect(mapped?.thumbnail).to(equal(thumbnail))
        expect(mapped?.pairings).to(haveCount(2))
        expect(mapped?.pairings).to(contain(["Sushi", "Pasta"]))
    }
    
    func testTranslateEntityWithNoVariety() {
        // Given
        let wineId = UUID()
        let type = ManagedWineType(context: coreData.context)
        type.name = "My Wine Type"
        let managedWine = ManagedWine(context: coreData.context)
        managedWine.wineId = wineId
        managedWine.type = type
        managedWine.name = "My Cool Wine"
        managedWine.rating = 3
        
        // When
        let mapped = sut.map(from: managedWine)
        
        // Then
        expect(mapped).toNot(beNil())
        expect(mapped?.type.name).to(equal("My Wine Type"))
        expect(mapped?.variety).to(beNil())
    }
}
