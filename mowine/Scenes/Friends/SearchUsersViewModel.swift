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

class SearchUsersViewModel: ObservableObject {
    @Published var hasSearched = false
    @Published var searchResults: [UsersService.UserSearchResult] = []
    
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
        searchTextSubject
            .print()
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .tryMap { self.searchUsers($0) }
            .switchToLatest()
            .catch { error -> Empty<[UsersService.UserSearchResult], Never> in
                SwiftyBeaver.error("\(error)")
                return Empty<[UsersService.UserSearchResult], Never>()
            }
            .assign(to: &$searchResults)
    }
    
    func searchTextDidChange(to searchText: String) {
        searchTextSubject.send(searchText)
    }
    
    private func searchUsers(_ searchText: String) -> AnyPublisher<[UsersService.UserSearchResult], Error> {
        if searchText.isEmpty {
            hasSearched = false
            return Empty<[UsersService.UserSearchResult], Error>().eraseToAnyPublisher()
        } else {
            return users.searchUsers(for: searchText)
                .map { self.mapUserResults($0) }
                .handleEvents(receiveOutput: { _ in self.hasSearched = true })
                .eraseToAnyPublisher()
        }
    }

    private func mapUserResults(_ users: [User]) -> [UsersService.UserSearchResult] {
        users.map { .fromUser($0) }
    }
}
