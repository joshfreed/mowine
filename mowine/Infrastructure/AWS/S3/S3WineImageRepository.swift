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
import SwiftyBeaver

class S3WineImageRepository {
    let transferUtility: AWSS3TransferUtility
    let session: Session
    let baseBucket = "mowine3586f516ef894a65a88b1c6a187dcf27/protected"
    
    init(transferUtility: AWSS3TransferUtility, session: Session) {
        self.transferUtility = transferUtility
        self.session = session
    }
    
    private func uploadImage(image: Data, bucket: String, imageName: String) {
        SwiftyBeaver.info("Starting upload \(imageName)")
        
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = {(task, progress) in
            DispatchQueue.main.async {
                // Do something e.g. Update a progress bar.
                SwiftyBeaver.verbose("Upload \(imageName): \(progress.fractionCompleted)")
            }
        }
        
        var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
        completionHandler = { (task, error) -> Void in
            DispatchQueue.main.async {
                // Do something e.g. Alert a user for transfer completion.
                // On failed uploads, `error` contains the error object.
                SwiftyBeaver.info("\(imageName): Upload completion handler! \(error)")
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
                SwiftyBeaver.error("Error: \(error.localizedDescription)")
            }
            
            if let _ = task.result {
                // Do something with uploadTask.
                SwiftyBeaver.debug("Upload task complete?!?")
            }
            
            return nil
        }
    }
    
    private func downloadImage(fileName: String, userBucket: String, completion: @escaping (Result<Data?>) -> ()) {
        SwiftyBeaver.info("Starting download \(fileName)")
        
        let expression = AWSS3TransferUtilityDownloadExpression()
        expression.progressBlock = { task, progress in
            DispatchQueue.main.async {
                // Do something e.g. Update a progress bar.
                SwiftyBeaver.verbose("Download \(fileName): \(progress.fractionCompleted)")
            }
        }
        
        let completionHandler: AWSS3TransferUtilityDownloadCompletionHandlerBlock = { task, url, data, error  in
            DispatchQueue.main.async {
                SwiftyBeaver.info("\(fileName): download completion handler \(error)")
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
                SwiftyBeaver.error("Error: \(error.localizedDescription)")
            }
            
            if let _ = task.result {
                // Do something with uploadTask.
                SwiftyBeaver.debug("Download task complete?!?")
            }
            
            return nil
        }
    }
}

// MARK: - WineImageRepository

extension S3WineImageRepository: WineImageRepository {
    func store(wineId: WineId, image: Data, thumbnail: Data) {
        guard let userId = session.currentUserId else {
            return
        }
        
        let userBucket = "\(baseBucket)/\(userId)"
        
        let thumbnailName = "\(wineId)-thumb.png"
        uploadImage(image: thumbnail, bucket: userBucket, imageName: thumbnailName)
        
        let imageName = "\(wineId).png"
        uploadImage(image: image, bucket: userBucket, imageName: imageName)
    }
    
    
    func fetchThumbnail(wineId: WineId, userId: UserId, completion: @escaping (Result<Data?>) -> ()) {
        let userBucket = "\(baseBucket)/\(userId)"
        let thumbnailName = "\(wineId)-thumb.png"
        downloadImage(fileName: thumbnailName, userBucket: userBucket, completion: completion)
    }
    
    func fetchPhoto(wineId: WineId, completion: @escaping (Result<Data?>) -> ()) {
        guard let userId = session.currentUserId else {
            return
        }
        
        let userBucket = "\(baseBucket)/\(userId)"
        let thumbnailName = "\(wineId).png"
        downloadImage(fileName: thumbnailName, userBucket: userBucket, completion: completion)
    }
    
    func deleteImages(wineId: WineId) {
        
    }
}
