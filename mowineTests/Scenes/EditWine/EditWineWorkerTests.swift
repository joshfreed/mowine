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
import Nimble
import Model

class EditWineWorkerTests: XCTestCase {
    // MARK: - Subject under test

    var sut: EditWineService!
    var imageWorker = MockWineImageWorker()
    var wine: Wine!
    let wineRepo = MockWineRepository()
    let typeRepo = MockWineTypeRepository()
    
    var red: WineType!
    var other: WineType!

    // MARK: - Test lifecycle

    override func setUp() {
        super.setUp()
        setupEditWineWorker()
        
        let merlot = WineVariety(name: "Merlot")
        let variety2 = WineVariety(name: "Other Variety")
        
        red = WineType(name: "Red", varieties: [merlot, variety2])
        other = WineType(name: "Other", varieties: [])
        
        wine = Wine(
            userId: UserId(string: UUID().uuidString),
            type: red,
            variety: merlot,
            name: "Test Wine",
            rating: 5
        )
        
        typeRepo.types = [red, other]
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: - Test setup

    func setupEditWineWorker() {
        sut = EditWineService(
            wineRepository: wineRepo,
            wineTypeRepository: typeRepo,
            imageWorker: imageWorker
        )
    }

    // MARK: - Test doubles

    // MARK: - Tests

    func testUpdateWine() {
        // Given
        var request = SaveWineRequest(name: "New Name", rating: 4, type: "Red")
        request.variety = "Other Variety"
        request.location = "Wegmans"
        request.notes = "Wine tasted good"
        request.price = "400"
        request.pairings = ["Tacos", "Sushi"]
        sut.getWineTypes() { _ in }

        // When
        sut.updateWine(wine: wine, from: request) { _ in  }

        // Then
        expect(self.wine.variety?.name).to(equal("Other Variety"))
        expect(self.wine.name).to(equal(request.name))
        expect(self.wine.rating).to(equal(request.rating))
        expect(self.wine.location).to(equal(request.location))
        expect(self.wine.notes).to(equal(request.notes))
        expect(self.wine.price).to(equal("400"))
        expect(self.wine.pairings).to(haveCount(2))
        expect(self.wine.pairings).to(contain(["Tacos", "Sushi"]))
//        XCTAssertNil(updatedWine?.photo)
//        XCTAssertNil(updatedWine?.thumbnail)
    }
    
    func testUpdateWine_changeType() {
        // Given
        var request = SaveWineRequest(name: "Test Wine", rating: 5, type: "Other")
        request.variety = "Other Variety"
        sut.getWineTypes() { _ in }
        
        // When
        sut.updateWine(wine: wine, from: request) { result in
            if case .failure = result {
                fail("Update failed")
            }
        }
        
        // Then
        expect(self.wine.type.name).to(equal("Other"))
    }
    
    func testUpdateWine_returnsErrorIfTypeNotInRepo() {
        // Given
        let request = SaveWineRequest(name: "Test Wine", rating: 5, type: "UNKNOWN")
        var error: Error?
        
        // When
        sut.updateWine(wine: wine, from: request) { result in
            if case let .failure(err) = result {
                error = err
            } else {
                fail("Update SHOULD have failed")
            }
        }
        
        // Then
        expect(error).to(matchError(EditWineServiceError.invalidWineType))
    }
    
    func testUpdateWine_nilVariety() {
        // Given
        sut.getWineTypes() { _ in }
        var request = SaveWineRequest(name: "Test Wine", rating: 5, type: "Red")
        request.variety = nil
        
        // When
        sut.updateWine(wine: wine, from: request) { result in
            if case .failure = result {
                fail("Update failed")
            }
        }
        
        // Then
        expect(self.wine.variety).to(beNil())
    }
    
}
