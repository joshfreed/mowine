//
//  MockProfilePictureWorker.swift
//  
//
//  Created by Josh Freed on 9/30/21.
//

import Foundation
import Model
import UIKit.UIImage

class MockProfilePictureWorker: ProfilePictureWorkerProtocol {
    func setProfilePicture(image: UIImage) async throws {
    }

    func getProfilePicture(url: URL) async throws -> Data? {
        nil
    }
}
