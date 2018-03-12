//
//  FriendsPresenterTests.swift
//  mowine
//
//  Created by Josh Freed on 3/7/18.
//  Copyright (c) 2018 Josh Freed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

@testable import mowine
import XCTest
import Nimble

class FriendsPresenterTests: XCTestCase {
    // MARK: Subject under test

    var sut: FriendsPresenter!
    let spy = FriendsDisplayLogicSpy()

    // MARK: Test lifecycle

    override func setUp() {
        super.setUp()
        setupFriendsPresenter()
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: Test setup

    func setupFriendsPresenter() {
        sut = FriendsPresenter()
        sut.viewController = spy
    }

    // MARK: Test doubles

    class FriendsDisplayLogicSpy: FriendsDisplayLogic {        
        var displayFriendsCalled = false
        func displayFriends(viewModel: Friends.FetchFriends.ViewModel) {
            displayFriendsCalled = true
        }
        
        var displayEmptySearchCalled = false
        func displayEmptySearch() {
            displayEmptySearchCalled = true
        }
        
        func displayLoadingSearchResults() {
            
        }
        
        var displaySearchResultsCalled = false
        var displaySearchResultsViewModel: Friends.SearchUsers.ViewModel?
        func displaySearchResults(viewModel: Friends.SearchUsers.ViewModel) {
            displaySearchResultsCalled = true
            displaySearchResultsViewModel = viewModel
        }
        
        func displayFriendAdded(viewModel: Friends.AddFriend.ViewModel) {
            
        }
        
        func displayAddFriendError(viewModel: Friends.AddFriend.ViewModel) {
            
        }
    }

    // MARK: Tests

    func testPresentFriends() {
        // Given
        let response = Friends.FetchFriends.Response(friends: [])

        // When
        sut.presentFriends(response: response)

        // Then
        XCTAssertTrue(self.spy.displayFriendsCalled, "presentSomething(response:) should ask the view controller to display the result")
    }
    
    func testPresentSearchResults() {
        // Given
        let user = UserBuilder.aUser().build()
        let response = Friends.SearchUsers.Response(matches: [user], myFriends: [])
        
        // When
        sut.presentSearchResults(response: response)
        
        // Then
        expect(self.spy.displaySearchResultsCalled).to(beTrue())
        let displayedUser = spy.displaySearchResultsViewModel?.matches.first
        expect(displayedUser?.userId).to(equal(user.id.description))
        expect(displayedUser?.fullName).to(equal(user.fullName))
        expect(displayedUser?.isFriend).to(beFalse())
    }
    
    func testPresentSearchResults_setsTrueWhenMatchIsFriendsWithCurrentUser() {
        // Given
        let user1 = UserBuilder.aUser().build()
        let user2 = UserBuilder.aUser().build()
        let user3 = UserBuilder.aUser().build()
        let response = Friends.SearchUsers.Response(
            matches: [user1, user2, user3],
            myFriends: [user2]
        )
        
        // When
        sut.presentSearchResults(response: response)
        
        // Then
        let viewModel = spy.displaySearchResultsViewModel
        expect(viewModel?.matches).to(haveCount(3))
        expect(viewModel?.matches[0].isFriend).to(beFalse())
        expect(viewModel?.matches[1].isFriend).to(beTrue())
        expect(viewModel?.matches[2].isFriend).to(beFalse())
    }
}
