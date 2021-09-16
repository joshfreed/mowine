//
//  SearchUsersViewModel.swift
//  mowine
//
//  Created by Josh Freed on 3/2/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation
import Combine
import SwiftyBeaver
import Model
import FirebaseCrashlytics

@MainActor
class SearchUsersViewModel: ObservableObject {
    @Published var hasSearched = false
    @Published var searchResults: [UsersService.UserSearchResult] = []

    private var cancellable: AnyCancellable?
    private let users: UsersService
    private var searchTextSubject = PassthroughSubject<String, Never>()

    init(users: UsersService) {
        self.users = users
        registerListeners()
    }
    
    init() {
        self.users = try! JFContainer.shared.container.resolve()
        registerListeners()
    }
    
    private func registerListeners() {
        cancellable = searchTextSubject
            .print()
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                Task { [weak self] in
                    await self?.searchUsers(searchText)
                }
            }
    }
    
    func searchUsers(matching searchText: String) {
        searchTextSubject.send(searchText)
    }

    private func searchUsers(_ searchText: String) async {
        if searchText.isEmpty {
            hasSearched = false
            searchResults = []
        } else {
            do {
                let users = try await users.searchUsers(for: searchText)
                searchResults = users.map { .fromUser($0) }
                hasSearched = true
            } catch {
                SwiftyBeaver.error("\(error)")
                Crashlytics.crashlytics().record(error: error)
            }
        }
    }
}
