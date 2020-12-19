//
//  UserProfilePresenter.swift
//  mowine
//
//  Created by Josh Freed on 3/13/18.
//  Copyright (c) 2018 Josh Freed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol UserProfilePresentationLogic {
    func presentUserProfile(response: UserProfile.FetchUserProfile.Response)
    func presentProfilePicture(data: Data?)
    func presentFriendStatus(response: UserProfile.FetchFriendStatus.Response)
    func presentFriended(response: UserProfile.AddFriend.Response)
    func presentUnfriended(response: UserProfile.Unfriend.Response)
}

class UserProfilePresenter: UserProfilePresentationLogic {
    weak var viewController: UserProfileDisplayLogic?

    // MARK: Fetch user profile

    func presentUserProfile(response: UserProfile.FetchUserProfile.Response) {
        let viewModel = UserProfile.FetchUserProfile.ViewModel(
            fullName: response.user.fullName,
//            profilePicture: response.user.profilePicture ?? #imageLiteral(resourceName: "No Profile Picture"),
            userCellarTitle: makeUserCellarTitle(from: response.user)
        )
        viewController?.displayUserProfile(viewModel: viewModel)
    }
    
//    func presentProfilePicture() {
//        viewController?.presentProfilePicture()
//    }
    
    func makeUserCellarTitle(from user: User) -> String {
        if let firstName = user.firstName {
            return "\(firstName)'s Cellar"
        } else {
            return "Wine Cellar"
        }
    }
    
    func presentProfilePicture(data: Data?) {
        var image: UIImage!
        if let data = data {
            image = UIImage(data: data)
        } else {
            image = #imageLiteral(resourceName: "No Profile Picture")
        }
        viewController?.displayProfilePicture(image: image)
    }
    
    // MARK: Fetch friend status
    
    func presentFriendStatus(response: UserProfile.FetchFriendStatus.Response) {
        let viewModel = UserProfile.FetchFriendStatus.ViewModel(isFriend: response.isFriend)
        viewController?.displayFriendStatus(viewModel: viewModel)
    }
    
    // MARK: Add friend
    
    func presentFriended(response: UserProfile.AddFriend.Response) {
        let viewModel = UserProfile.AddFriend.ViewModel()
        viewController?.displayFriended(viewModel: viewModel)
    }
    
    // MARK: Unfriend
    
    func presentUnfriended(response: UserProfile.Unfriend.Response) {
        let viewModel = UserProfile.Unfriend.ViewModel()
        viewController?.displayUnfriended(viewModel: viewModel)
    }
}