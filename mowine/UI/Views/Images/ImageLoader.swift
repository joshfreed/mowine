//
//  ImageLoader.swift
//  mowine
//
//  Created by Josh Freed on 5/29/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation
import UIKit.UIImage
import Combine

protocol ImageLoader {
    func load(urlString: String) -> AnyPublisher<UIImage, Error>
}

enum ImageLoadingError: Error {
    case invalidUrl(String)
    case invalidImage
    case notFound
}
