//
// Created by Josh Freed on 5/8/21.
//

import Foundation
import CoreGraphics

public protocol WineImage {
    func resize(to desiredSize: CGSize) -> WineImage?
    func pngData() -> Data?
}

public struct WineImageName: Equatable {
    public let userId: UserId
    public let wineId: WineId

    public var name: String { "\(userId)/\(wineId).png" }

    public init(userId: UserId, wineId: WineId) {
        self.userId = userId
        self.wineId = wineId
    }
}

public protocol WineImageService {
    func fetchImage(named wineImageName: WineImageName) async throws -> WineImage?
}

public protocol WineImageFactory {
    func createImage(from data: Data) throws -> WineImage
}

public enum WineImageFactoryErrors: Error {
    case invalidImageData
}
