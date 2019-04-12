//
// Created by Josh Freed on 2019-01-14.
// Copyright (c) 2019 Josh Freed. All rights reserved.
//

import UIKit
import SwiftyBeaver
import JFLib

protocol ProfilePictureWorkerProtocol {
    func setProfilePicture(userId: UserId, image: UIImage, completion: @escaping (EmptyResult) -> ())
    func getProfilePicture(url: URL, completion: @escaping (Result<Data?>) -> ())
}

class ProfilePictureWorker<DataServiceType: DataServiceProtocol>: ProfilePictureWorkerProtocol
where
    DataServiceType.GetDataUrl == URL,
    DataServiceType.PutDataUrl == String
{
    let session: Session
    let profilePictureService: DataServiceType

    init(session: Session, profilePictureService: DataServiceType) {
        self.session = session
        self.profilePictureService = profilePictureService
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

        profilePictureService.putData(imageData, url: "\(userId)/profile.png") { result in
            switch result {
            case .success(let url): self.setPhotoUrl(url, completion: completion)
            case .failure(let error): completion(.failure(error))
            }
        }
    }

    private func setPhotoUrl(_ url: URL, completion: @escaping  (EmptyResult) -> ()) {
        session.setPhotoUrl(url, completion: completion)
    }
    
    func getProfilePicture(url: URL, completion: @escaping (Result<Data?>) -> ()) {
        profilePictureService.getData(url: url, completion: completion)
    }
}
