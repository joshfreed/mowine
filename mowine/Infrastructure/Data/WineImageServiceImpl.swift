//
//  WineImageServiceImpl.swift
//  mowine
//
//  Created by Josh Freed on 10/1/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation
import Model
import SwiftyBeaver

class WineImageServiceImpl<DataServiceType: DataServiceProtocol>: WineImageService
where
    DataServiceType.GetDataUrl == String,
    DataServiceType.PutDataUrl == String
{
    private let dataService: DataServiceType
    private let wineImageFactory: WineImageFactory

    init(dataService: DataServiceType, wineImageFactory: WineImageFactory) {
        self.dataService = dataService
        self.wineImageFactory = wineImageFactory
    }

    func fetchImage(named wineImageName: WineImageName) async throws -> WineImage? {
        SwiftyBeaver.info("Requested full res wine image: \(wineImageName)")

        do {
            let data = try await dataService.getData(url: wineImageName.name)
            return try wineImageFactory.createImage(from: data)
        } catch DataReadServiceErrors.objectNotFound {
            return nil
        }
    }
}
