//
//  UIImageWineImageService.swift
//  mowine
//
//  Created by Josh Freed on 9/30/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation
import UIKit.UIImage
import Model
import SwiftyBeaver

class UIImageWineImageService<DataServiceType: DataServiceProtocol>: WineImageService
where
    DataServiceType.GetDataUrl == String,
    DataServiceType.PutDataUrl == String
{
    private let dataService: DataServiceType
    
    init(dataService: DataServiceType) {
        self.dataService = dataService
    }

    func fetchImage(named wineImageName: WineImageName) async throws -> WineImage? {
        SwiftyBeaver.info("Requested full res wine image. WineId: \(wineImageName.wineId)")

        let data = try await dataService.getData(url: wineImageName.name)

        var photo: UIImage? = nil

        if let data = data {
            photo = UIImage(data: data)
        }

        return photo
    }
}

extension UIImage: WineImage {
    public func resize(to desiredSize: CGSize) -> WineImage? {
        let scale = min(desiredSize.width / size.width, desiredSize.height / size.height)
        let newSize = CGSize(width: size.width * scale, height: size.height * scale)

        var newImage: UIImage?

        UIGraphicsBeginImageContext(newSize)
        draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}
