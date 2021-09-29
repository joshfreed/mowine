//
//  FirebaseStorageLoader.swift
//  mowine
//
//  Created by Josh Freed on 5/29/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation
import Combine
import UIKit.UIImage

class FirebaseStorageLoader: ImageLoader {
    private let storage: FirebaseStorageService

    init(storage: FirebaseStorageService) {
        self.storage = storage
    }

    func load(urlString: String) -> AnyPublisher<UIImage, Error> {
        Future { [weak self] promise in
            Task { [weak self] in
                do {
                    let data = try await self?.storage.getData(path: urlString)
                    guard let data = data else {
                        promise(.failure(ImageLoadingError.notFound))
                        return
                    }
                    if let image = UIImage(data: data) {
                        promise(.success(image))
                    } else {
                        promise(.failure(ImageLoadingError.invalidImage))
                    }
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
