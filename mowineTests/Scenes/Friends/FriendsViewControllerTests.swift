//
//  FriendsViewControllerTests.swift
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

class FriendsViewControllerTests: XCTestCase {
    // MARK: Subject under test

    var sut: FriendsViewController!
    var window: UIWindow!
    let spy = FriendsBusinessLogicSpy()

    // MARK: Test lifecycle

    override func setUp() {
        super.setUp()
        window = UIWindow()
        setupFriendsViewController()
    }

    override func tearDown() {
        window = nil
        super.tearDown()
    }

    // MARK: Test setup

    func setupFriendsViewController() {
        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        sut = storyboard.instantiateViewController(withIdentifier:"FriendsViewController") as! FriendsViewController
        sut.interactor = spy
    }

    func loadView() {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }

    // MARK: Test doubles

    class FriendsBusinessLogicSpy: FriendsBusinessLogic {
        var fetchFriendsCalled = false
        func fetchFriends(request: Friends.FetchFriends.Request) {
            fetchFriendsCalled = true
        }
        
        func searchUsers(request: Friends.SearchUsers.Request) {
            
        }
        
        func cancelSearch() {
            
        }
        
        var addFriendCalled = false
        var addFriendRequest: Friends.AddFriend.Request?
        func addFriend(request: Friends.AddFriend.Request) {
            addFriendCalled = true
            addFriendRequest = request
        }

        func selectUser(request: Friends.SelectUser.Request) {

        }
    }
    
    class MockUserCell: UserTableViewCell {
        var displayFriendAddedCalled = false
        override func displayFriendAdded() {
            displayFriendAddedCalled = true
        }
        
        var displayAddFriendFailedCalled = false
        override func displayAddFriendFailed() {
            displayAddFriendFailedCalled = true
        }
    }

    // MARK: Tests

    func testShouldDoSomethingWhenViewIsLoaded() {
        // Given

        // When
        loadView()

        // Then
        XCTAssertTrue(spy.fetchFriendsCalled, "viewDidLoad() should ask the interactor to do something")
    }

    func testDisplayFriends() {
        // Given
        let viewModel = Friends.FetchFriends.ViewModel(friends: [])

        // When
        loadView()
        sut.displayFriends(viewModel: viewModel)

        // Then
        //XCTAssertEqual(sut.nameTextField.text, "", "displaySomething(viewModel:) should update the name text field")
    }
    
    func testAddFriend() {
        // Given
        
        // When
        loadView()
        sut.addFriend(userId: "12345")
        
        // Then
        expect(self.spy.addFriendCalled).to(beTrue())
        expect(self.spy.addFriendRequest?.userId).to(equal("12345"))
    }
    
    func testAddFriendWithCellCallsInteractor() {
        // Given
        let userId = "12345"
        let cell = MockUserCell()
        
        // When
        sut.addFriend(cell: cell, userId: userId)
        
        // Then
        expect(self.spy.addFriendCalled).to(beTrue())
        expect(self.spy.addFriendRequest?.userId).to(equal("12345"))
    }
    
    func testAddFriendSavesTheCellThatTriggeredIt() {
        // Given
        let userId = "12345"
        let cell = MockUserCell()
        
        // When
        sut.addFriend(cell: cell, userId: userId)
        
        // Then
        expect(self.sut.friendCells[userId]).to(be(cell))
    }
    
    func testDisplayFriendAdded_shouldCallDisplayFriendAddedOnTheCell() {
        // Given
        let userId = "12345"
        let viewModel = Friends.AddFriend.ViewModel(userId: userId)
        let cell = MockUserCell()
        sut.friendCells[userId] = cell
        
        // When
        loadView()
        sut.displayFriendAdded(viewModel: viewModel)
        
        // Then
        expect(cell.displayFriendAddedCalled).to(beTrue())        
    }
    
    func testDisplayFriendAdded_shouldUpdateTheDisplayedUser() {
        // Given
        let userId = "12345"
        let viewModel = Friends.AddFriend.ViewModel(userId: userId)
        let userModel = Friends.DisplayedUser(userId: "12345", fullName: "Whatever", profilePicture: UIImage(), isFriend: false)
        sut.displayedUsers.append(userModel)
        
        // When
        loadView()
        sut.displayFriendAdded(viewModel: viewModel)
        
        // Then
        expect(self.sut.displayedUsers[0].isFriend).to(beTrue())
    }
    
    func testDisplayAddFriendError() {
        // Given
        let userId = "12345"
        let viewModel = Friends.AddFriend.ViewModel(userId: userId)
        let cell = MockUserCell()
        sut.friendCells[userId] = cell
        
        // When
        loadView()
        sut.displayAddFriendError(viewModel: viewModel)
        
        // Then
        expect(cell.displayAddFriendFailedCalled).to(beTrue())
    }
}
