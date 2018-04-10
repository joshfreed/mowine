//
//  CoreDataWineRepositoryTests.swift
//  mowineTests
//
//  Created by Josh Freed on 2/22/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import XCTest
@testable import mowine
import CoreData
import Nimble

class CoreDataWineRepositoryTests: XCTestCase {
    var sut: CoreDataWineRepository!
    let coreData = CoreDataHelper()
    var type: WineType!
    var variety: WineVariety!
    var variety2: WineVariety!
    var wine: Wine!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        coreData.setUp()
        let wineEntityMapper = CoreDataWineTranslator(context: coreData.container.viewContext)
        sut = CoreDataWineRepository(container: coreData.container, wineEntityMapper: wineEntityMapper)
        
        variety = WineVariety(name: "Merlot")
        variety2 = WineVariety(name: "Chianti")
        type = WineType(name: "Red", varieties: [variety, variety2])
        wine = Wine(type: type, variety: variety, name: "Freed 2015", rating: 5)
        wine.location = "Wegman's"
        wine.notes = "These are some notes about this delicious wine"
        wine.price = "47.99"
        wine.photo = Data(repeating: 88, count: 44)
        wine.thumbnail = Data(repeating: 22, count: 10)
        wine.pairings = ["Sushi", "Pizza"]
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: Save
    
    func testSaveNewWine() {
        // Given
        coreData.insert(variety)
        coreData.insert(variety2)
        coreData.insert(type)
        coreData.save()
        
        // When
        sut.save(wine) { _ in }
        
        // Then
        let actual = loadById(wine.id)
        expect(actual).toNot(beNil())
        expect(actual?.wineId).to(equal(wine.id))
        expect(actual?.name).to(equal("Freed 2015"))
        expect(actual?.rating).to(equal(5))
        expect(actual?.type).toNot(beNil())
        expect(actual?.type?.name).to(equal("Red"))
        expect(actual?.variety).toNot(beNil())
        expect(actual?.variety?.name).to(equal("Merlot"))
        expect(actual?.location).to(equal("Wegman's"))
        expect(actual?.notes).to(equal("These are some notes about this delicious wine"))
        expect(actual?.price).to(equal(47.99))
        expect(actual?.image).to(equal(wine.photo))
        expect(actual?.thumbnail).to(equal(wine.thumbnail))
        expect(actual?.pairings).to(haveCount(2))
        expect(actual?.pairings).to(containElementSatisfying({ ($0 as! ManagedFood).name == "Sushi" }))
        expect(actual?.pairings).to(containElementSatisfying({ ($0 as! ManagedFood).name == "Pizza" }))
    }
    
    func testSaveUpdatesExistingWine() {
        // Given
        coreData.insert(variety)
        coreData.insert(variety2)
        coreData.insert(type)
        coreData.insert(wine)
        coreData.save()
        let updated: Wine = wine
        updated.variety = variety2
        updated.name = "Bing Bong"
        updated.rating = 1
        updated.location = "My Pants"
        updated.notes = "This is a different note"
        updated.price = "99.99"
        updated.photo = Data(repeating: 99, count: 10)
        updated.thumbnail = Data(repeating: 99, count: 2)
        updated.pairings = ["Sushi", "Bananas", "Mango"]
        
        // When
        sut.save(updated) { _ in }
        
        // Then
        expect(self.wineCount()).to(equal(1))
        let actual = loadById(wine.id)
        expect(actual).toNot(beNil())
        expect(actual?.wineId).to(equal(wine.id))
        expect(actual?.name).to(equal("Bing Bong"))
        expect(actual?.rating).to(equal(1))
        expect(actual?.variety).toNot(beNil())
        expect(actual?.variety?.name).to(equal("Chianti"))
        expect(actual?.location).to(equal(updated.location))
        expect(actual?.notes).to(equal(updated.notes))
        expect(actual?.price).to(equal(99.99))
        expect(actual?.image).to(equal(updated.photo))
        expect(actual?.thumbnail).to(equal(updated.thumbnail))
        expect(actual?.pairings).to(haveCount(3))
        expect(actual?.pairings).to(containElementSatisfying({ ($0 as! ManagedFood).name == "Sushi" }))
        expect(actual?.pairings).to(containElementSatisfying({ ($0 as! ManagedFood).name == "Bananas" }))
        expect(actual?.pairings).to(containElementSatisfying({ ($0 as! ManagedFood).name == "Mango" }))
    }
    
    // MARK: Get my wines
    
    func testGetMyWines() {
        // Given
        let wine1 = WineBuilder.aWine().withType(type).build()
        let wine2 = WineBuilder.aWine().withType(type).build()
        let wine3 = WineBuilder.aWine().withType(type).build()
        coreData.insert(type)
        coreData.insert(wine1)
        coreData.insert(wine2)
        coreData.insert(wine3)
        coreData.save()
        var actual: [Wine] = []
        
        // When
        sut.getMyWines { result in
            if case let .success(wines) = result {
                actual = wines
            }
        }
        
        // Then
        expect(actual).to(haveCount(3))
        expect(actual).to(containElementSatisfying({ $0.id == wine1.id }))
        expect(actual).to(containElementSatisfying({ $0.id == wine2.id }))
        expect(actual).to(containElementSatisfying({ $0.id == wine3.id }))
    }
    
    // MARK: Delete
    
    func testDeleteWine() {
        // Given
        let wine = WineBuilder.aWine().withVariety(variety).build()
        coreData.insert(variety)
        coreData.insert(wine)
        coreData.save()
        var callbackWasCalled = false
        
        // When
        sut.delete(wine) { result in
            callbackWasCalled = true
        }
        
        // Then
        expect(callbackWasCalled).to(equal(true))
        expect(self.wineCount()).to(equal(0))
        let actual = loadById(wine.id)
        expect(actual).to(beNil())
    }
    
    // MARK: Helpers
    
    private func wineCount() -> Int {
        let request: NSFetchRequest<ManagedWine> = ManagedWine.fetchRequest()
        
        do {
            let count: Int = try coreData.container.viewContext.count(for: request)
            return count
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    private func loadById(_ id: UUID) -> ManagedWine? {
        let request: NSFetchRequest<ManagedWine> = ManagedWine.fetchRequest()
        request.predicate = NSPredicate(format: "wineId == %@", id as CVarArg)
        
        do {
            return try coreData.container.viewContext.fetch(request).first
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
