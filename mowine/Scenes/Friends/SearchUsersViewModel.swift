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
import MoWine_Application

@MainActor
class SearchUsersViewModel: ObservableObject {
    @Published var hasSearched = false
    @Published var searchResults: [UsersService.UserSearchResult] = []

    @Injected private var users: UsersService

    private var cancellable: AnyCancellable?
    private var searchTextSubject = PassthroughSubject<String, Never>()

    init() {
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
                CrashReporter.shared.record(error: error)
            }
        }
    }
}
