//
// Created by Josh Freed on 2019-01-14.
// Copyright (c) 2019 Josh Freed. All rights reserved.
//

import UIKit
import SwiftyBeaver

class ProfilePictureWorker {
    let imageService: ImageServiceProtocol
    let session: Session

    init(imageService: ImageServiceProtocol, session: Session) {
        self.imageService = imageService
        self.session = session
    }

    func setProfilePicture(userId: UserId, image: UIImage) {
        guard
            let downsizedImage = image.resize(to: CGSize(width: 400, height: 400)),
            let imageData = downsizedImage.pngData(),
            let thumbnailImage = image.resize(to: CGSize(width: 150, height: 150)),
            let thumbnailData = thumbnailImage.pngData()
        else {
            return
        }

        imageService.storeImage(name: "\(userId)/profile.png", data: imageData) { result in 
            if case let .failure(error) = result {
                SwiftyBeaver.error("\(error)")
            }
        }

        imageService.storeImage(name: "\(userId)/profile-thumb.png", data: thumbnailData) { result in 
            switch result {
            case .success(let url): self.setPhotoUrl(url)
            case .failure(let error): SwiftyBeaver.error("\(error)")
            }
        }
    }

    private func setPhotoUrl(_ url: URL) {
        session.setPhotoUrl(url) { result in
            if case let .failure(error) = result {
                SwiftyBeaver.error("\(error)")
            }
        }
    }
}
