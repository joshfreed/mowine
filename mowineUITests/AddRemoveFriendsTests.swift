//
//  AddRemoveFriendsTests.swift
//  mowineUITests
//
//  Created by Josh Freed on 10/23/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import XCTest

class AddRemoveFriendsTests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false

        let app = XCUIApplication()
        app.launchArguments.append("UI_TESTING")
        app.launchEnvironment["loggedInUser"] = ["emailAddress": "gus@jpfreed.com", "password": "Testing123!"].toJsonString()
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAddAndRemoveFriend() throws {
        let app = XCUIApplication()

        let tabBar = try TabBar(app: app)

        var friendsPage = try tabBar.selectFriendsTab()
        XCTAssertEqual(0, friendsPage.friendCount)

        var searchPage = try friendsPage.searchUsers(for: "Xander")
        XCTAssertTrue(searchPage.addFriendButtonExists(for: "Xander Crews"))

        searchPage = try searchPage.addFriend("Xander Crews")
        XCTAssertFalse(searchPage.addFriendButtonExists(for: "Xander Crews"))

        friendsPage = try searchPage.cancelSearch()
        XCTAssertEqual(1, friendsPage.friendCount)

        let myFriend = try friendsPage.getFriend(name: "Xander Crews")
        XCTAssertEqual("Xander Crews", myFriend.name)
        XCTAssertEqual("No Profile Picture", myFriend.profilePictureLabel)

        var userProfilePage = try myFriend.tap()

        XCTAssertEqual("Xander Crews", userProfilePage.name)
        XCTAssertEqual("No Profile Picture", userProfilePage.profilePicture)
        XCTAssertEqual("Friends", userProfilePage.friendButtonTitle)

        userProfilePage = try userProfilePage
            .removeFriend()
            .confirm()

        XCTAssertEqual("Add Friend", userProfilePage.friendButtonTitle)

        friendsPage = try userProfilePage.goBack()
        XCTAssertEqual(0, friendsPage.friendCount)
    }
}
