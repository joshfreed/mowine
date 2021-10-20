//
//  MockWineImageService.swift
//  
//
//  Created by Josh Freed on 9/30/21.
//

import XCTest
import MoWine_Domain

class MockWineImageStorage: WineImageStorage {

    // MARK: - putImage

    func putImage(wineId: WineId, size: WineImageSize, data: Data) async throws {

    }

    // MARK: - getImage(wineId:size:)

    private var getImageResult: Result<Data, Error>!
    private var getImage_wasCalled = false
    private var getImage_wineId: WineId?
    private var getImage_size: WineImageSize?

    func getImage(wineId: WineId, size: WineImageSize) async throws -> Data {
        getImage_wasCalled = true
        getImage_wineId = wineId
        getImage_size = size

        switch getImageResult! {
        case .success(let data): return data
        case .failure(let error): throw error
        }
    }

    func configure_getImage_toReturn(_ data: Data) {
        getImageResult = .success(data)
    }

    func configure_getImage_toThrow(_ error: Error) {
        getImageResult = .failure(error)
    }

    func verify_getImage_wasCalled(
        withWineId expectedWineId: WineId,
        andSize expectedSize: WineImageSize,
        file: StaticString = #file, line: UInt = #line
    ) {
        XCTAssertTrue(getImage_wasCalled, file: file, line: line)
        XCTAssertEqual(expectedWineId, getImage_wineId, file: file, line: line)
        XCTAssertEqual(expectedSize, getImage_size, file: file, line: line)
    }
}
