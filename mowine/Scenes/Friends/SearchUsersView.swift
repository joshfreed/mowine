//
//  SearchUsersView.swift
//  mowine
//
//  Created by Josh Freed on 2/17/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI
import Combine
import SwiftyBeaver

struct SearchUsersView: View {
    @EnvironmentObject var users: UsersService
    @ObservedObject var searchBar: SearchBar
    @State private var hasSearched = false
    @State private var searchResults: [UsersService.UserSearchResult] = []
    
    var body: some View {
        SearchUsersInnerView(hasSearched: hasSearched, searchResults: searchResults)
            .onReceive(
                searchBar.$text
                    .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
                    .removeDuplicates()
                    .tryMap { self.searchUsers($0) }
                    .switchToLatest()
                    .catch { error -> Empty<[UsersService.UserSearchResult], Never> in
                        SwiftyBeaver.error("\(error)")
                        return Empty<[UsersService.UserSearchResult], Never>()
                    }
            ) {
                searchResults = $0
            }
    }

    private func searchUsers(_ searchText: String) -> AnyPublisher<[UsersService.UserSearchResult], Error> {
        if searchText.isEmpty {
            hasSearched = false
            return Empty<[UsersService.UserSearchResult], Error>().eraseToAnyPublisher()
        } else {
            return users.searchUsers(for: searchText)
                .map { mapUserResults($0) }
                .handleEvents(receiveOutput: { _ in self.hasSearched = true })
                .eraseToAnyPublisher()
        }
    }

    private func mapUserResults(_ users: [User]) -> [UsersService.UserSearchResult] {
        users.map { .fromUser($0) }
    }
}

struct SearchUsersInnerView: View {
    let hasSearched: Bool
    let searchResults: [UsersService.UserSearchResult]

    var body: some View {
        if hasSearched {
            if searchResults.isEmpty {
                SearchUsersMessage(message: "No users match your search.")
            } else {
                List(searchResults) {
                    UserSearchResultView(user: $0)
                }
            }
        } else {
            SearchUsersMessage(message: "Try searching for people you know")
        }
    }
}

struct SearchUsersMessage: View {
    let message: String
    
    var body: some View {
        VStack {
            Text(message)
                .font(.system(size: 21))
                .foregroundColor(Color("Text Label"))
            Spacer()
        }.padding(.top, 24)
    }
}

struct SearchFriendsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchUsersView(searchBar: SearchBar())
            .environmentObject(UsersService.make())
    }
}
