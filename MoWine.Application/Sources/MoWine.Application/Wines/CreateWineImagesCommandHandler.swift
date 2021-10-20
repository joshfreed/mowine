//
//  CreateWineImagesCommandHandler.swift
//  
//
//  Created by Josh Freed on 10/1/21.
//

import Foundation
import CoreGraphics
import MoWine_Domain

public struct CreateWineImagesCommand {
    public let wineId: String
    public let data: Data
}

public class CreateWineImagesCommandHandler {
    private let wineImageStorage: WineImageStorage
    private let imageResizer: ImageResizer

    public init(wineImageStorage: WineImageStorage, imageResizer: ImageResizer) {
        self.wineImageStorage = wineImageStorage
        self.imageResizer = imageResizer
    }
    
    public func handle(_ command: CreateWineImagesCommand) async throws {
        let wineId = WineId(string: command.wineId)

        let fullSize = CGSize(width: 400, height: 400)
        let fullData = try imageResizer.resize(data: command.data, to: fullSize)
        try await wineImageStorage.putImage(wineId: wineId, size: .full, data: fullData)

        let thumbSize = CGSize(width: 150, height: 150)
        let thumbData = try imageResizer.resize(data: command.data, to: thumbSize)
        try await wineImageStorage.putImage(wineId: wineId, size: .thumbnail, data: thumbData)
    }
}
