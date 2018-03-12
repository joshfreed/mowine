//
//  FriendsInteractor.swift
//  mowine
//
//  Created by Josh Freed on 3/6/18.
//  Copyright (c) 2018 Josh Freed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol FriendsBusinessLogic {
    func fetchFriends(request: Friends.FetchFriends.Request)
    func searchUsers(request: Friends.SearchUsers.Request)
    func cancelSearch()
    func addFriend(request: Friends.AddFriend.Request)
}

protocol FriendsDataStore {
    
}

class FriendsInteractor: FriendsBusinessLogic, FriendsDataStore {
    var presenter: FriendsPresentationLogic?
    var worker: FriendsWorker?

    private var friends: [User] {
        return worker?.friends ?? []
    }
    private(set) var searchTimer: Timer?
    private(set) var debounceTime = 0.25
    
    // MARK: Fetch Friends

    func fetchFriends(request: Friends.FetchFriends.Request) {        
        worker?.fetchMyFriends() { result in
            switch result {
            case .success(let friends): self.presentFriends(friends)
            case .failure(let error): print("\(error)")
            }
        }
    }
    
    private func presentFriends(_ friends: [User]) {
        let response = Friends.FetchFriends.Response(friends: friends)
        presenter?.presentFriends(response: response)
    }
    
    // MARK: Search Users

    private var searches: [UUID] = []
    
    func searchUsers(request: Friends.SearchUsers.Request) {
        print("Searching for: \(request.searchString)")

        cancelSearchTimer()
        
        guard !request.searchString.isEmpty else {
            presentFriends(friends)
            return
        }

        print("Scheduling a search after \(debounceTime) seconds")
        
        searchTimer = Timer.scheduledTimer(withTimeInterval: debounceTime, repeats: false, block: { _ in
            self.doSearch(request: request)
        })
    }
    
    private func doSearch(request: Friends.SearchUsers.Request) {
        let searchJobId = UUID()
        
        print("doSearch \(searchJobId) \(request.searchString)")
        
        searches.append(searchJobId)
        
        worker?.searchUsers(searchString: request.searchString) { result in
            print("Work complete for \(request.searchString)")
            
            switch result {
            case .success(let users):
                guard self.searches.contains(searchJobId) else {
                    return
                }
                print("Presenting search results for \(searchJobId), \(request.searchString)")
                self.presentSearchResults(users: users)
            case .failure(let error): print("\(error)")
            }
        }
    }
    
    private func presentSearchResults(users: [User]) {
        let response = Friends.SearchUsers.Response(matches: users, myFriends: friends)
        presenter?.presentSearchResults(response: response)
    }
    
    private func cancelSearchTimer() {
        searchTimer?.invalidate()
        searchTimer = nil
        searches = []
    }
    
    // MARK: Cancel search
    
    func cancelSearch() {
        cancelSearchTimer()
        presentFriends(friends)
    }
    
    // MARK: Add friend
    
    func addFriend(request: Friends.AddFriend.Request) {
        guard let userId = UserId(string: request.userId) else {
            return
        }
        
        worker?.addFriend(userId: userId) { result in
            switch result {
            case .success:
                let response = Friends.AddFriend.Response(userId: request.userId)
                self.presenter?.presentAddFriend(response: response)
            case .failure(let error):
                print("\(error)")
                let response = Friends.AddFriend.Response(userId: request.userId)
                self.presenter?.presentAddFriendError(response: response)
            }
        }
    }
}
