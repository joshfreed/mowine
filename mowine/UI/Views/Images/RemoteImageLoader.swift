//
//  RemoteImageLoader.swift
//  ConstantImprovers
//
//  Created by Josh Freed on 2/7/20.
//  Copyright © 2020 Clay Steadman. All rights reserved.
//

import UIKit
import SwiftyBeaver
import FirebaseCrashlytics

fileprivate let imageCache = NSCache<AnyObject, UIImage>()

class RemoteImageLoader: ObservableObject {
    @Published var state: RemoteImageLoaderState = .noImage {
        didSet {
            SwiftyBeaver.verbose("RemoteImageLoader state changed to \(state)")
        }
    }

    init(urlString: String) {
        SwiftyBeaver.verbose("RemoteImageLoader is fetching: \(urlString)")

        guard !urlString.isEmpty else {
            state = .noImage
            return
        }

        guard
            let encodedUrl = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: encodedUrl)
        else {
            let nsError = NSError.appError(code: .invalidUrl, userInfo: ["url": urlString])
            Crashlytics.crashlytics().record(error: nsError)
            state = .noImage
            return
        }

        if let image = imageCache.object(forKey: url as NSURL) {
            SwiftyBeaver.verbose("loaded from cache")
            self.state = .loaded(image: image)
            return
        }

        state = .loading

        SwiftyBeaver.verbose("URLSession.shared.dataTask(with: \(url)")

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    self.state = .error
                    Crashlytics.crashlytics().record(error: error)
                    return
                }
                guard let data = data, let image = UIImage(data: data) else {
                    self.state = .error
                    return
                }

                imageCache.setObject(image, forKey: url as NSURL)

                self.state = .loaded(image: image)
            }
        }.resume()
    }
}

enum RemoteImageLoaderState {
    case noImage
    case loading
    case loaded(image: UIImage)
    case error
}
