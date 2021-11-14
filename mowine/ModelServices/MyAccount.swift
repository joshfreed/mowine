//
//  MyAccount.swift
//  mowine
//
//  Created by Josh Freed on 11/13/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation
import Combine
import MoWine_Application

class MyAccount: ObservableObject {
    @Published var fullName: String = ""
    @Published var emailAddress: String = ""
    @Published var profilePicture: UserPhoto = .url(nil)

    @Injected private var session: Session
    @Injected private var getMyAccount: GetMyAccountQueryHandler

    private var cancellable: AnyCancellable?

    func load() {
        guard cancellable == nil else { return }

        cancellable = session
            .currentUserIdPublisher
            .removeDuplicates()
            .compactMap { [weak self] _ in self?.getMyAccount.subscribe() }
            .switchToLatest()
            .replaceError(with: nil)
            .compactMap { $0 }
            .receive(on: RunLoop.main)
            .print("MyAccountCombine")
            .sink { [weak self] response in self?.present(response) }
    }
}

// MARK: Presentation

extension MyAccount {
    func present(_ response: GetMyAccountQueryResponse) {
        fullName = response.fullName
        emailAddress = response.emailAddress
        profilePicture = .url(response.profilePictureUrl)
    }
}

// MARK: Fakes

extension MyAccount {
    static func fake() -> MyAccount {
        let myAccount = MyAccount()
        myAccount.fullName = "Barry Jones"
        myAccount.emailAddress = "bjones@test.com"
        return myAccount
    }
}
