//
//  SearchUsersViewModel.swift
//  mowine
//
//  Created by Josh Freed on 3/2/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation
import Combine
import JFLib_Mediator
import MoWine_Application

@MainActor
class SearchUsersViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published private(set) var hasSearched = false
    @Published private(set) var searchResults: [SearchUsersResponse.User] = []

    @Injected private var mediator: Mediator

    private var cancellable: AnyCancellable?

    init() {
        registerListeners()
    }
    
    private func registerListeners() {
        cancellable = $searchText
            .print()
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                Task { [weak self] in
                    await self?.searchUsers(searchText)
                }
            }
    }

    private func searchUsers(_ searchText: String) async {
        if searchText.isEmpty {
            hasSearched = false
            searchResults = []
        } else {
            do {
                let response: SearchUsersResponse = try await mediator.send(SearchUsersQuery(searchString: searchText))
                searchResults = response.users
                hasSearched = true
            } catch {
                CrashReporter.shared.record(error: error)
            }
        }
    }
}
