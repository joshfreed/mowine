//
//  ProfilePictureWorkerProtocol.swift
//  
//
//  Created by Josh Freed on 9/30/21.
//

import Foundation
import UIKit.UIImage

public protocol ProfilePictureWorkerProtocol {
    func setProfilePicture(image: UIImage) async throws
    func getProfilePicture(url: URL) async throws -> Data?
}
