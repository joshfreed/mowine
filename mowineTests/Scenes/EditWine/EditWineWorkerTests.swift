//
//  EditWineWorkerTests.swift
//  mowine
//
//  Created by Josh Freed on 6/4/17.
//  Copyright (c) 2017 BleepSmazz. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

@testable import mowine
import XCTest
import CoreData

class EditWineWorkerTests: XCTestCase {
    // MARK: - Subject under test

    var sut: EditWineWorker!
    var varietyTranslator = MockVarietyTranslator()
    var imageWorker = MockWineImageWorker()
    var context: NSManagedObjectContext!
    var wine: Wine!

    // MARK: - Test lifecycle

    override func setUp() {
        super.setUp()
        setupEditWineWorker()
        context = setUpInMemoryManagedObjectContext()
        wine = NSEntityDescription.insertNewObject(forEntityName: "Wine", into: context) as! Wine
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: - Test setup

    func setupEditWineWorker() {
        sut = EditWineWorker(
            varietyTranslator: varietyTranslator,
            imageWorker: imageWorker
        )
    }

    // MARK: - Test doubles

    // MARK: - Tests

    func testSaveWine() {
        // Given
        var request = EditWine.SaveWine.Request(name: "New Name", rating: 4, type: WineTypeViewModel(name: "Thing", varieties: []), variety: "Merlot")
        request.location = "Wegmans"
        request.notes = "Wine tasted good"
        request.price = 400

        // When
        do {
            try sut.saveWine(wine: wine, request: request)
        } catch {
            XCTAssert(false)
        }

        // Then
        XCTAssertEqual(wine.name, request.name)
        XCTAssertEqual(wine.rating, request.rating)
        XCTAssertEqual(wine.location, request.location)
        XCTAssertEqual(wine.notes, request.notes)
        XCTAssertEqual(wine.price, 400)
        XCTAssertNil(wine.image)
        XCTAssertNil(wine.thumbnail)
    }
    
    func testMergePairingsAddsNewPairings() {
        sut.mergePairings(wine: wine, pairings: ["Sushi", "Cheese"])

        let pairings = getPairings()
        XCTAssertEqual(2, pairings.count)
        XCTAssertTrue(pairings.contains(where: { $0.name == "Sushi" }))
        XCTAssertTrue(pairings.contains(where: { $0.name == "Cheese" }))
    }

    func testMergePairingsDoesNotAddTheSamePairingTwice() {
        addPairing("Sushi")
        
        sut.mergePairings(wine: wine, pairings: ["Sushi"])
        
        let pairings = getPairings()
        XCTAssertEqual(1, pairings.count)
        XCTAssertTrue(pairings.contains(where: { $0.name == "Sushi" }))
    }
    
    func testMergePairingsRemovesMissingPairing() {
        addPairing("Sushi")
        addPairing("Cheese")
        
        sut.mergePairings(wine: wine, pairings: ["Cheese"])
        
        let pairings = getPairings()
        XCTAssertEqual(1, pairings.count)
        XCTAssertTrue(pairings.contains(where: { $0.name == "Cheese" }))
    }

    func testMergePairingsIsNotCaseSensative() {
        addPairing("Sushi")
        
        sut.mergePairings(wine: wine, pairings: ["sUSHi"])
        
        let pairings = getPairings()
        XCTAssertEqual(1, pairings.count)
        XCTAssertTrue(pairings.contains(where: { $0.name == "Sushi" }))
    }
    
    private func getPairings() -> [Food] {
        if let pairings = Array(wine.pairings ?? []) as? [Food] {
            XCTAssertNotNil(pairings)
            return pairings
        } else {
            XCTFail("Could not unwrap pairings nset")
            return []
        }
    }
    
    private func addPairing(_ foodName: String) {
        let food = NSEntityDescription.insertNewObject(forEntityName: "Food", into: context) as! Food
        food.name = foodName
        wine.addToPairings(food)
    }
}
