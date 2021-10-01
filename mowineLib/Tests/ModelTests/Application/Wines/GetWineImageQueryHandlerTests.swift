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

class GetWineImageQueryHandlerTests: XCTestCase {
    var sut: GetWineImageQueryHandler!
    let mockSession = MockSession()
    let mockWineImageService = MockWineImageService()
    let wineId = WineId()
    let userId = UserId()

    override func setUpWithError() throws {
        sut = .init(session: mockSession, wineImageService: mockWineImageService)
    }

    func test_getWineImage_image_not_found() async throws {
        mockSession.login(userId: userId)
        let image = try await sut.handle(wineId: wineId.asString)
        XCTAssertNil(image)
    }

    func test_getWineImage_returns_the_image() async throws {
        let expectedName = WineFullImageName(userId: userId, wineId: wineId)
        let expectedImage = TestWineImage()
        mockSession.login(userId: userId)
        mockWineImageService.imageToReturn = expectedImage

        let image = try await sut.handle(wineId: wineId.asString)

        XCTAssertEqual(expectedImage, image as? TestWineImage)
        XCTAssertEqual(expectedName, mockWineImageService.wineImageName as? WineFullImageName)
    }

    func test_getWineImage_throws_exception_if_not_logged_in() async {
        do {
            _ = try await sut.handle(wineId: wineId.asString)
            XCTFail("Expected to throw error, but succeeded")
        } catch {
            XCTAssertEqual(error as? SessionError, .notLoggedIn)
        }
    }
}

struct TestWineImage: WineImage, Equatable {
    let rando = UUID().uuidString

    func resize(to desiredSize: CGSize) -> WineImage? { nil }
    func pngData() -> Data? { nil }
}
