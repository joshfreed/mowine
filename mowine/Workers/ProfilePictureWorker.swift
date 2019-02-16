//
// Created by Josh Freed on 2019-01-14.
// Copyright (c) 2019 Josh Freed. All rights reserved.
//

import UIKit
import SwiftyBeaver
import JFLib

class ProfilePictureWorker {
    let imageService: ImageServiceProtocol
    let session: Session

    init(imageService: ImageServiceProtocol, session: Session) {
        self.imageService = imageService
        self.session = session
    }

    func setProfilePicture(userId: UserId, image: UIImage, completion: @escaping (EmptyResult) -> ()) {
        guard
            let downsizedImage = image.resize(to: CGSize(width: 400, height: 400)),
            let imageData = downsizedImage.pngData(),
            let thumbnailImage = image.resize(to: CGSize(width: 150, height: 150)),
            let thumbnailData = thumbnailImage.pngData()
        else {
            return
        }

        imageService.storeImage(name: "\(userId)/profile.png", data: imageData) { result in
            switch result {
            case .success(let url): self.setPhotoUrl(url, completion: completion)
            case .failure(let error): completion(.failure(error))
            }
        }

        /*
        imageService.storeImage(name: "\(userId)/profile-thumb.png", data: thumbnailData) { result in 
            switch result {
            case .success(let url): self.setPhotoUrl(url, completion: completion)
            case .failure(let error): SwiftyBeaver.error("\(error)")
            }
        }
        */
    }

    private func setPhotoUrl(_ url: URL, completion: @escaping  (EmptyResult) -> ()) {
        session.setPhotoUrl(url) { result in
            switch result {
            case .success: completion(.success)
            case .failure(let error): completion(.failure(error))
            }
        }
    }
}
