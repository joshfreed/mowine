//
//  GetWineImageQueryHandler.swift
//  GetWineImageQueryHandler
//
//  Created by Josh Freed on 9/8/21.
//

import Foundation

public class GetWineImageQueryHandler {
    let session: Session
    let wineImageService: WineImageService

    public init(session: Session, wineImageService: WineImageService) {
        self.session = session
        self.wineImageService = wineImageService
    }

    public func handle(wineId: String) async throws -> WineImage? {
        guard let userId = session.currentUserId else { throw SessionError.notLoggedIn }
        let wineId = WineId(string: wineId)
        let imageName = WineFullImageName(userId: userId, wineId: wineId)
        return try await wineImageService.fetchImage(named: imageName)
    }
}
