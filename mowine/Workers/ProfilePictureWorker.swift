//
// Created by Josh Freed on 2019-01-14.
// Copyright (c) 2019 Josh Freed. All rights reserved.
//

import UIKit
import SwiftyBeaver

class ProfilePictureWorker {
    let imageService: ImageService
    let session: Session

    init(imageService: ImageService, session: Session) {
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

        imageService.storeImage(name: "\(userId)/profile.png", data: imageData)
        imageService.storeImage(name: "\(userId)/profile-thumb.png", data: thumbnailData)

        let photoUrl = URL(string: "\(userId)/profile-thumb.png")!
        session.setPhotoUrl(photoUrl) { result in
            switch result {
            case .success: break
            case .failure(let error):
                SwiftyBeaver.error("Error setting photo url: \(error)")
            }
        }
    }
}
