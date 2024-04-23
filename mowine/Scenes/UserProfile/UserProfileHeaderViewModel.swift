//
//  UserProfileHeaderViewModel.swift
//  mowine
//
//  Created by Josh Freed on 3/3/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation
import JFLib_Mediator
import MoWine_Application
import OSLog

class UserProfileHeaderViewModel: ObservableObject {
    @Published var fullName: String = ""
    @Published var profilePicture: URL?

    @Injected private var mediator: Mediator
    private let logger = Logger(category: .ui)

    @MainActor
    func load(userId: String) async {
        do {
            let profile: GetPublicProfileResponse = try await mediator.send(GetPublicProfileQuery(userId: userId))
            fullName = profile.fullName
            profilePicture = profile.profilePictureUrl
        } catch {
            logger.error("\(error)")
            CrashReporter.shared.record(error: error)
        }
    }
}
