//
//  StoryViewModelTests.swift
//  StoriesAppTests
//
//  Created by Pauline Nomballais on 16/06/2026.
//

import XCTest
@testable import StoriesApp

@MainActor
final class StoryViewModelTests: XCTestCase {

    private var router: AppRouterMock!
    private var persistenceMock: PersistenceServiceMock!
    private var persistence: StoryPersistence!
    private var appState: AppState!
    private var viewModel: StoryViewModel!

    override func setUp() {
        super.setUp()
        router = AppRouterMock()
        persistenceMock = PersistenceServiceMock()
        persistence = StoryPersistence(service: persistenceMock)
        appState = AppState()
        appState.stories = StoryServiceMock.mockStories
        viewModel = StoryViewModel(
            router: router,
            persistence: persistence,
            appState: appState,
            startIndex: 0
        )
    }

    override func tearDown() {
        router = nil
        persistenceMock = nil
        persistence = nil
        appState = nil
        viewModel = nil
        super.tearDown()
    }

    func testGoToNextItem_shouldIncrementItemIndex() {
        viewModel.goToNextItem()
        XCTAssertEqual(viewModel.currentItemIndex, 1)
    }

    func testGoToPreviousItem_whenIndexIsZero_shouldNotDecrement() {
        viewModel.goToPreviousItem()
        XCTAssertEqual(viewModel.currentItemIndex, 0)
    }

    func testGoToNextItem_whenLastItem_shouldGoToNextStory() {
        let firstStoryId = viewModel.currentStory.user.id
        viewModel.goToNextItem()
        viewModel.goToNextItem()
        viewModel.goToNextItem()
        XCTAssertNotEqual(viewModel.currentStory.user.id, firstStoryId)
    }

    func testMarkCurrentItemAsSeen_shouldSaveToService() {
        viewModel.markCurrentItemAsSeen()
        XCTAssertTrue(persistenceMock.seenItems.contains(viewModel.currentStoryItem.imageURL))
    }

    func testToggleLike_shouldAddLike() {
        viewModel.toggleLikeCurrentItem()
        XCTAssertTrue(viewModel.isCurrentItemLiked)
    }

    func testToggleLike_whenAlreadyLiked_shouldRemoveLike() {
        viewModel.toggleLikeCurrentItem()
        viewModel.toggleLikeCurrentItem()
        XCTAssertFalse(viewModel.isCurrentItemLiked)
    }

    func testDismiss_shouldCallRouter() {
        viewModel.dismiss()
        XCTAssertTrue(router.didDismiss)
    }

    func testNavigateToNextStory_whenLastStory_shouldTriggerLoadMore() {
        appState.stories = [StoryServiceMock.mockStories[0]]
        viewModel = StoryViewModel(
            router: router,
            persistence: persistence,
            appState: appState,
            startIndex: 0
        )
        viewModel.navigateToStory(direction: .next)
        XCTAssertTrue(appState.shouldLoadMorePage)
    }

    func testInit_whenFirstItemSeen_shouldStartOnSecondItem() {
        let story = StoryServiceMock.mockStories[0]
        persistence.state.seenItemIds.insert(story.items[0].imageURL)
        viewModel = StoryViewModel(
            router: router,
            persistence: persistence,
            appState: appState,
            startIndex: 0
        )
        XCTAssertEqual(viewModel.currentItemIndex, 1)
    }

    func testInit_whenAllItemsSeen_shouldStartOnFirstItem() {
        let story = StoryServiceMock.mockStories[0]
        story.items.forEach { persistence.state.seenItemIds.insert($0.imageURL) }
        viewModel = StoryViewModel(
            router: router,
            persistence: persistence,
            appState: appState,
            startIndex: 0
        )
        XCTAssertEqual(viewModel.currentItemIndex, 0)
    }

    func testProgressBarWidth_forPreviousIndex_shouldReturnTotalWidth() {
        viewModel.goToNextItem()
        let width = viewModel.progressBarWidth(for: 0, totalWidth: 100)
        XCTAssertEqual(width, 100)
    }

    func testProgressBarWidth_forFutureIndex_shouldReturnZero() {
        let width = viewModel.progressBarWidth(for: 2, totalWidth: 100)
        XCTAssertEqual(width, 0)
    }

    func testProgressBarWidth_forCurrentIndex_shouldReturnPartialWidth() {
        let width = viewModel.progressBarWidth(for: 0, totalWidth: 100)
        XCTAssertEqual(width, viewModel.currentItemProgress * 100, accuracy: 0.01)
    }

    func testGoToPreviousItem_whenIndexIsZero_shouldResetProgress() {
        viewModel.goToPreviousItem()
        XCTAssertEqual(viewModel.currentItemProgress, 0)
    }

    func testNavigateToPreviousStory_whenFirstStory_shouldNotChangeStory() {
        let firstStoryId = viewModel.currentStory.user.id
        viewModel.navigateToStory(direction: .previous)
        XCTAssertEqual(viewModel.currentStory.user.id, firstStoryId)
    }

    func testGoToNextItem_whenLastItem_shouldChangeStory() {
        let firstStoryId = viewModel.currentStory.user.id
        while viewModel.currentItemIndex < viewModel.currentStory.items.count - 1 {
            viewModel.goToNextItem()
        }
        viewModel.goToNextItem()
        XCTAssertNotEqual(viewModel.currentStory.user.id, firstStoryId)
    }
}
