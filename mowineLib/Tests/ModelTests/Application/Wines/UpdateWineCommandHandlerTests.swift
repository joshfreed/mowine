//
//  UpdateWineCommandHandlerTests.swift
//  UpdateWineCommandHandlerTests
//
//  Created by Josh Freed on 9/6/21.
//

import XCTest
@testable import Model
@testable import ModelTestHelpers
import Nimble

class UpdateWineCommandHandlerTests: XCTestCase {
    var sut: UpdateWineCommandHandler!
    let mockWineRepository = MockWineRepository()
    let mockImageWorker = MockWineImageWorker()
    let mockWineTypeRepository = MockWineTypeRepository()

    var wine: Wine!
    var red: WineType!
    var other: WineType!

    override func setUpWithError() throws {
        sut = UpdateWineCommandHandler(
            wineRepository: mockWineRepository,
            imageWorker: mockImageWorker,
            wineTypeRepository: mockWineTypeRepository
        )

        let merlot = WineVariety(name: "Merlot")
        let variety2 = WineVariety(name: "Other Variety")
        let variety3 = WineVariety(name: "Other Variety")

        red = WineType(name: "Red", varieties: [merlot, variety2])
        other = WineType(name: "Other", varieties: [variety3])

        wine = Wine(
            userId: UserId(string: UUID().uuidString),
            type: red,
            variety: merlot,
            name: "Test Wine",
            rating: 5
        )

        mockWineTypeRepository.types = [red, other]
    }

    func test_handle_happyPath() async throws {
        // Given
        mockWineRepository.getWine(by: wine.id, willReturn: wine)
        var command = UpdateWineCommand(wineId: wine.id.asString, name: "New Name", rating: 4, type: "Red")
        command.variety = "Other Variety"
        command.location = "Wegmans"
        command.notes = "Wine tasted good"
        command.price = "400"
        command.pairings = ["Tacos", "Sushi"]

        // When
        try await sut.handle(command)

        // Then
        mockWineRepository.verify_save_wasCalled(with: wine)
        expect(self.wine.variety?.name).to(equal("Other Variety"))
        expect(self.wine.name).to(equal(command.name))
        expect(self.wine.rating).to(equal(command.rating))
        expect(self.wine.location).to(equal(command.location))
        expect(self.wine.notes).to(equal(command.notes))
        expect(self.wine.price).to(equal("400"))
        expect(self.wine.pairings).to(haveCount(2))
        expect(self.wine.pairings).to(contain(["Tacos", "Sushi"]))
    }

    func test_handle_updates_wine_to_different_type() async throws {
        // Given
        mockWineRepository.getWine(by: wine.id, willReturn: wine)
        var command = UpdateWineCommand(wineId: wine.id.asString, name: "Test Wine", rating: 5, type: "Other")
        command.variety = "Other Variety"

        // When
        try await sut.handle(command)

        // Then
        expect(self.wine.type.name).to(equal("Other"))
        expect(self.wine.variety?.name).to(equal("Other Variety"))
    }

    func test_handle_changes_variety_to_nil() async throws {
        // Given
        mockWineRepository.getWine(by: wine.id, willReturn: wine)
        var command = UpdateWineCommand(wineId: wine.id.asString, name: "Test Wine", rating: 5, type: "Red")
        command.variety = nil

        // When
        try await sut.handle(command)

        // Then
        expect(self.wine.variety).to(beNil())
    }

    func test_handle_throws_error_if_wine_not_found() async {
        // Given
        mockWineRepository.getWine(by: wine.id, willReturn: nil)
        let command = UpdateWineCommand(wineId: wine.id.asString, name: "Test Wine", rating: 5, type: "UNKNOWN")
        var error: Error?

        // When
        do {
            try await sut.handle(command)
        } catch let err {
            error = err
        }

        // Then
        expect(error).to(matchError(UpdateWineError.wineNotFound))
    }

    func test_handle_throws_error_if_wine_type_not_found() async {
        // Given
        mockWineRepository.getWine(by: wine.id, willReturn: wine)
        let command = UpdateWineCommand(wineId: wine.id.asString, name: "Test Wine", rating: 5, type: "UNKNOWN")
        var error: Error?

        // When
        do {
            try await sut.handle(command)
        } catch let err {
            error = err
        }

        // Then
        expect(error).to(matchError(UpdateWineError.invalidWineType))
    }
}
