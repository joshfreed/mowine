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
        try await withCheckedThrowingContinuation { continuation in
            imageWorker.fetchPhoto(wineId: WineId(string: wineId)) { result in
                switch result {
                case .success(let data):
                    // TODO convert to WineImage, remove UIKit reference
                    var photo: UIImage? = nil
                    if let data = data {
                        photo = UIImage(data: data)
                    }
                    continuation.resume(returning: photo as? WineImage)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
