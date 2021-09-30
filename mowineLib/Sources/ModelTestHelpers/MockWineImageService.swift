//
//  MockWineImageService.swift
//  
//
//  Created by Josh Freed on 9/30/21.
//

import Foundation
@testable import Model

class MockWineImageService: WineImageService {
    var imageToReturn: WineImage?
    var wineImageName: WineImageName?

    func fetchImage(named wineImageName: WineImageName) async throws -> WineImage? {
        self.wineImageName = wineImageName
        return imageToReturn
    }
}
