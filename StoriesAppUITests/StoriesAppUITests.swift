//
//  StoriesAppUITests.swift
//  StoriesAppUITests
//
//  Created by Pauline Nomballais on 15/06/2026.
//

import XCTest

final class StoriesAppUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["UI_TESTING"]
        app.launch()
    }

    override func tearDown() {
        app = nil
        super.tearDown()
    }

    func testStoryList_shouldDisplayAvatars() {
        let storiesList = app.scrollViews.firstMatch
        XCTAssertTrue(storiesList.exists)
    }

    func testTapOnAvatar_shouldOpenStoryViewer() {
        let firstAvatar = app.staticTexts["story_avatar_user-1"]
        firstAvatar.tap()

        let dismissButton = app.buttons["dismiss_button"]
        XCTAssertTrue(dismissButton.waitForExistence(timeout: 5))
    }

    func testDismissButton_shouldCloseStoryViewer() {
        let firstAvatar = app.staticTexts["story_avatar_user-1"]
        XCTAssertTrue(firstAvatar.waitForExistence(timeout: 5))
        firstAvatar.tap()

        let dismissButton = app.buttons["dismiss_button"]
        XCTAssertTrue(dismissButton.waitForExistence(timeout: 3))
        dismissButton.tap()

        XCTAssertFalse(dismissButton.exists)
    }

    func testLikeButton_shouldToggle() {
        let firstAvatar = app.staticTexts["story_avatar_user-1"]
        XCTAssertTrue(firstAvatar.waitForExistence(timeout: 2))
        firstAvatar.tap()

        let likeButton = app.buttons["like_button"]
        XCTAssertTrue(likeButton.waitForExistence(timeout: 10))
        likeButton.tap()

        XCTAssertTrue(likeButton.exists)
    }

    @MainActor
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
