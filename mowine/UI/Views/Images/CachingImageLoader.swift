//
//  CachingImageLoader.swift
//  mowine
//
//  Created by Josh Freed on 5/29/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation
import UIKit.UIImage
import Combine
import SwiftyBeaver

fileprivate let imageCache = NSCache<AnyObject, UIImage>()

class CachingImageLoader: ImageLoader {
    private let otherLoader: ImageLoader

    init(otherLoader: ImageLoader) {
        self.otherLoader = otherLoader
    }

    func load(urlString: String) -> AnyPublisher<UIImage, Error> {
        let key = urlString as NSString

        if let image = imageCache.object(forKey: key) {
            SwiftyBeaver.verbose("loaded from cache")
            return Just(image).setFailureType(to: Error.self).eraseToAnyPublisher()
        } else {
            return otherLoader.load(urlString: urlString)
                .handleEvents(receiveOutput: { image in imageCache.setObject(image, forKey: key) })
                .eraseToAnyPublisher()
        }
    }
}
