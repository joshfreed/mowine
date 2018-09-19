//
//  S3WineImageRepository.swift
//  mowine
//
//  Created by Josh Freed on 4/10/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import AWSS3
import JFLib

class S3WineImageRepository {
    let transferUtility: AWSS3TransferUtility
    let session: Session
    let baseBucket = "mowine-wine-images"
    
    init(transferUtility: AWSS3TransferUtility, session: Session) {
        self.transferUtility = transferUtility
        self.session = session
    }
    
    private func uploadImage(image: Data, bucket: String, imageName: String) {
        print("Starting upload \(imageName)")
        
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = {(task, progress) in
            DispatchQueue.main.async {
                // Do something e.g. Update a progress bar.
                print("Upload \(imageName): \(progress.fractionCompleted)")
            }
        }
        
        var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
        completionHandler = { (task, error) -> Void in
            DispatchQueue.main.async {
                // Do something e.g. Alert a user for transfer completion.
                // On failed uploads, `error` contains the error object.
                print("\(imageName): Upload completion handler! \(error)")
            }
        }
        
        transferUtility.uploadData(
            image,
            bucket: bucket,
            key: imageName,
            contentType: "image/png",
            expression: expression,
            completionHandler: completionHandler
        ).continueWith { task in
            if let error = task.error {
                print("Error: \(error.localizedDescription)")
            }
            
            if let _ = task.result {
                // Do something with uploadTask.
                print("Upload task complete?!?")
            }
            
            return nil
        }
    }
    
    private func downloadImage(fileName: String, userBucket: String, completion: @escaping (Result<Data?>) -> ()) {
        print("Starting download \(fileName)")
        
        let expression = AWSS3TransferUtilityDownloadExpression()
        expression.progressBlock = { task, progress in
            DispatchQueue.main.async {
                // Do something e.g. Update a progress bar.
                print("Download \(fileName): \(progress.fractionCompleted)")
            }
        }
        
        let completionHandler: AWSS3TransferUtilityDownloadCompletionHandlerBlock = { task, url, data, error  in
            DispatchQueue.main.async {
                print("\(fileName): download completion handler \(error)")
                completion(.success(data))
            }
        }
        
        transferUtility.downloadData(
            fromBucket: userBucket,
            key: fileName,
            expression: expression,
            completionHandler: completionHandler
        ).continueWith { task in
            if let error = task.error {
                print("Error: \(error.localizedDescription)")
            }
            
            if let _ = task.result {
                // Do something with uploadTask.
                print("Download task complete?!?")
            }
            
            return nil
        }
    }
}

// MARK: - WineImageRepository

extension S3WineImageRepository: WineImageRepository {
    func store(wineId: UUID, image: Data, thumbnail: Data) {
        guard let userId = session.currentUserId else {
            return
        }
        
        let userBucket = "\(baseBucket)/\(userId)"
        
        let thumbnailName = "\(wineId)-thumb.png"
        uploadImage(image: thumbnail, bucket: userBucket, imageName: thumbnailName)
        
        let imageName = "\(wineId).png"
        uploadImage(image: image, bucket: userBucket, imageName: imageName)
    }
    
    
    func fetchThumbnail(wineId: UUID, completion: @escaping (Result<Data?>) -> ()) {
        guard let userId = session.currentUserId else {
            return
        }
        
        let userBucket = "\(baseBucket)/\(userId)"
        let thumbnailName = "\(wineId)-thumb.png"
        downloadImage(fileName: thumbnailName, userBucket: userBucket, completion: completion)
    }
    
    func fetchPhoto(wineId: UUID, completion: @escaping (Result<Data?>) -> ()) {
        guard let userId = session.currentUserId else {
            return
        }
        
        let userBucket = "\(baseBucket)/\(userId)"
        let thumbnailName = "\(wineId).png"
        downloadImage(fileName: thumbnailName, userBucket: userBucket, completion: completion)
    }
    
    func deleteImages(wineId: UUID) {
        
    }
}
