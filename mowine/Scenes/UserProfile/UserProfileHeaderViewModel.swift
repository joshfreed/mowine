//
//  UserProfileHeaderViewModel.swift
//  mowine
//
//  Created by Josh Freed on 3/3/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation
import Combine
import SwiftyBeaver
import Model
import FirebaseCrashlytics

class UserProfileHeaderViewModel: ObservableObject {
    @Published var fullName: String = ""
    @Published var profilePictureUrl: String = ""
    
    private let userId: String
    private let users: UsersService
    private var cancellables = Set<AnyCancellable>()

    init(userId: String, users: UsersService) {
        self.userId = userId
        self.users = users
    }
    
    func load() async {
        do {
            let user = try await users.getUserById(userId)
            fullName = user.fullName
            profilePictureUrl = user.profilePictureUrl?.absoluteString ?? ""
        } catch {
            Crashlytics.crashlytics().record(error: error)
            SwiftyBeaver.error("\(error)")
        }
    }
}
