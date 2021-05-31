//
//  URLSessionImageLoader.swift
//  mowine
//
//  Created by Josh Freed on 5/29/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation
import UIKit.UIImage
import Combine
import SwiftyBeaver

class URLSessionImageLoader: ImageLoader {
    func load(urlString: String) -> AnyPublisher<UIImage, Error> {
        guard let url = URL(string: urlString) else {
            let error = ImageLoadingError.invalidUrl(urlString)
            return Fail(error: error).eraseToAnyPublisher()
        }

        SwiftyBeaver.verbose("URLSession.shared.dataTask(with: \(url)")

        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    let statusCode = (element.response as? HTTPURLResponse)?.statusCode
                    SwiftyBeaver.error("HTTP Response status code: \(String(describing: statusCode))")
                    throw URLError(.badServerResponse)
                }
                return element.data
            }
            .tryMap { data -> UIImage in
                guard let image = UIImage(data: data) else {
                    throw ImageLoadingError.invalidImage
                }
                return image
            }
            .eraseToAnyPublisher()
    }
}
