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
            self?.storage.getData(path: urlString) { result in
                switch result {
                case .success(let data):
                    guard let data = data else {
                        promise(.failure(ImageLoadingError.notFound))
                        return
                    }
                    if let image = UIImage(data: data) {
                        promise(.success(image))
                    } else {
                        promise(.failure(ImageLoadingError.invalidImage))
                    }
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
