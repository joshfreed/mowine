//
//  GetWineImageQueryHandlerTests.swift
//  
//
//  Created by Josh Freed on 9/30/21.
//

import XCTest
@testable import Model
@testable import ModelTestHelpers
import Nimble
import MoWine_Domain

class GetWineImageQueryHandlerTests: XCTestCase {
    var sut: GetWineImageQueryHandler!
    let mockWineImageStorage = MockWineImageStorage()
    let wineId = WineId()

    override func setUpWithError() throws {
        sut = .init(wineImageStorage: mockWineImageStorage)
    }

    func test_getWineImage_image_not_found() async throws {
        mockWineImageStorage.configure_getImage_toThrow(WineImageStorageErrors.imageNotFound)

        let image = try await sut.handle(wineId: wineId.asString)

        XCTAssertNil(image)
    }

    func test_getWineImage_returns_the_image() async throws {
        let data = Data(repeating: 1, count: 100)
        mockWineImageStorage.configure_getImage_toReturn(data)

        let actual = try await sut.handle(wineId: wineId.asString)

        XCTAssertEqual(data, actual)
        mockWineImageStorage.verify_getImage_wasCalled(withWineId: wineId, andSize: .full)
    }
}
