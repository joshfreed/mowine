//
//  GetWineImageQueryHandler.swift
//  GetWineImageQueryHandler
//
//  Created by Josh Freed on 9/8/21.
//

import Foundation
import UIKit.UIImage

public class GetWineImageQueryHandler {
    let imageWorker: WineImageWorkerProtocol

    public init(imageWorker: WineImageWorkerProtocol) {
        self.imageWorker = imageWorker
    }

    public func handle(wineId: String) async throws -> WineImage? {
        let data = try await imageWorker.fetchPhoto(wineId: WineId(string: wineId))

        // TODO convert to WineImage, remove UIKit reference
        var photo: UIImage? = nil

        if let data = data {
            photo = UIImage(data: data)
        }

        return photo as? WineImage
    }
}
