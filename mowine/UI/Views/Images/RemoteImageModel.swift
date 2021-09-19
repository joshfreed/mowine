//
//  RemoteImageModel.swift
//  mowine
//
//  Created by Josh Freed on 2/7/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import UIKit
import SwiftyBeaver
import FirebaseCrashlytics
import Combine

class RemoteImageModel: ObservableObject {
    @Published var state: RemoteImageState = .noImage {
        didSet {
            SwiftyBeaver.verbose("RemoteImageLoader state changed to \(state)")
        }
    }

    private var cancellables = Set<AnyCancellable>()
    private let imageLoader: ImageLoader

    init(imageLoader: ImageLoader) {
        self.imageLoader = CachingImageLoader(otherLoader: imageLoader)
    }

    init() {
        let imageLoader: ImageLoader = try! JFContainer.shared.resolve()
        self.imageLoader = CachingImageLoader(otherLoader: imageLoader)
    }

    func load(urlString: String) {
        SwiftyBeaver.verbose("RemoteImageLoader is fetching: \(urlString)")

        guard !urlString.isEmpty else {
            state = .noImage
            return
        }

        state = .loading

        imageLoader
            .load(urlString: urlString)
            .print()
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    Crashlytics.crashlytics().record(error: error)
                    SwiftyBeaver.error("\(error)")
                    self?.state = .error
                }
            } receiveValue: { [weak self] image in
                self?.state = .loaded(image: image)
            }
            .store(in: &cancellables)
    }
}

enum RemoteImageState {
    case noImage
    case loading
    case loaded(image: UIImage)
    case error
}
