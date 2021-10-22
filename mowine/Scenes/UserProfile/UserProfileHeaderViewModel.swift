//
//  UserProfileHeaderViewModel.swift
//  mowine
//
//  Created by Josh Freed on 3/3/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation
import Combine
import MoWine_Application

@MainActor
class UserProfileHeaderViewModel: ObservableObject {
    @Published var fullName: String = ""
    @Published var profilePicture: URL?

    @Injected private var users: UsersService

    private var cancellables = Set<AnyCancellable>()

    func load(userId: String) async {
        do {
            let user = try await users.getUserById(userId)
            fullName = user.fullName
            profilePicture = user.profilePictureUrl
        } catch {
            CrashReporter.shared.record(error: error)
        }
    }
}
