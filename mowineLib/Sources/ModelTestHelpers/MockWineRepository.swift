//
//  MockWineRepository.swift
//  MockWineRepository
//
//  Created by Josh Freed on 9/6/21.
//

import XCTest
import Model

class MockWineRepository: WineRepository {

    // MARK: getWine(by:)

    var getWineById_wasCalled = false
    var getWineById_wineId: WineId?
    var getWineById_wine: Wine?

    func getWine(by id: WineId, willReturn wine: Wine?) {
        getWineById_wine = wine
    }

    func getWine(by id: WineId) async throws -> Wine? {
        getWineById_wasCalled = true
        getWineById_wineId = id
        return getWineById_wine
    }

    func getWine(by id: WineId, completion: @escaping (Swift.Result<Wine, Error>) -> ()) {

    }

    // MARK: add

    func add(_ wine: Wine) async throws {}

    // MARK: getWines

    func getWines(userId: UserId, completion: @escaping (Swift.Result<[Wine], Error>) -> ()) -> MoWineListenerRegistration {
        return FakeRegistration()
    }

    // MARK: save

    private var save_wasCalled = false
    private var save_wine: Wine?
    private var save_error: Error?

    func save(_ wine: Wine) async throws {
        save_wasCalled = true
        save_wine = wine
    }

    func verify_save_wasCalled(with expected: Wine, file: StaticString = #file, line: UInt = #line) {
        XCTAssertTrue(save_wasCalled, file: file, line: line)
        XCTAssertEqual(expected, save_wine, file: file, line: line)
    }

    // MARK: delete

    func delete(_ wineId: WineId) async throws {}

    func getTopWines(userId: UserId, completion: @escaping (Swift.Result<[Wine], Error>) -> ()) {

    }

    func getWines(userId: UserId, wineType: WineType, completion: @escaping (Swift.Result<[Wine], Error>) -> ()) -> MoWineListenerRegistration {
        return FakeRegistration()
    }

    func getTopWines(userId: UserId) async throws -> [Wine] {
        []
    }

    func getWineTypeNamesWithAtLeastOneWineLogged(userId: UserId) async throws -> [String] {
        []
    }
}
