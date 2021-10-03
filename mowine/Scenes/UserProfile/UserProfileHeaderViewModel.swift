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

@MainActor
class UserProfileHeaderViewModel: ObservableObject {
    @Published var fullName: String = ""
    @Published var profilePicture: URL?
    
    private let userId: String
    private let users: UsersService
    private var cancellables = Set<AnyCancellable>()

    init(userId: String, users: UsersService) {
        self.userId = userId
        self.users = users
    }

    convenience init(userId: String) {
        self.init(userId: userId, users: try! JFContainer.shared.resolve())
    }
    
    func load() async {
        do {
            let user = try await users.getUserById(userId)
            fullName = user.fullName
            profilePicture = user.profilePictureUrl
        } catch {
            Crashlytics.crashlytics().record(error: error)
            SwiftyBeaver.error("\(error)")
        }
    }
}
