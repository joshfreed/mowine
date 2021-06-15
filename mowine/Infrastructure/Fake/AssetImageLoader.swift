//
//  AssetImageLoader.swift
//  mowine
//
//  Created by Josh Freed on 6/14/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation
import UIKit.UIImage
import Combine

class AssetImageLoader: ImageLoader {
    func load(urlString: String) -> AnyPublisher<UIImage, Error> {
        guard let image = UIImage(named: urlString) else {
            return Fail(error: ImageLoadingError.notFound).eraseToAnyPublisher()
        }
        return Just(image).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
