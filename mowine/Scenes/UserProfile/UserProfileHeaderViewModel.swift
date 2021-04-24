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

class UserProfileHeaderViewModel: ObservableObject {
    @Published var fullName: String = ""
    @Published var profilePictureUrl: String = ""
    
    private let userId: String
    private let users: UsersService
    private var cancellables = Set<AnyCancellable>()
    
    init(userId: String) {
        self.userId = userId
        self.users = try! JFContainer.shared.container.resolve()
    }
    
    init(userId: String, users: UsersService) {
        self.userId = userId
        self.users = users
    }
    
    func load() {
        users
            .getUserById(userId)
            .catch { error -> Empty<User, Never> in
                return Empty<User, Never>()
            }
            .sink { [weak self] user in
                self?.fullName = user.fullName
                self?.profilePictureUrl = user.profilePictureUrl?.absoluteString ?? ""
            }
            .store(in: &cancellables)
    }
}
