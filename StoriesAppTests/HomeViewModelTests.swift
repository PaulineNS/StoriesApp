//
//  HomeViewModelTests.swift
//  StoriesAppTests
//
//  Created by Pauline Nomballais on 16/06/2026.
//

import XCTest
@testable import StoriesApp

@MainActor
final class HomeViewModelTests: XCTestCase {

    private var router: AppRouterMock!
    private var persistenceMock: PersistenceServiceMock!
    private var persistence: StoryPersistence!
    private var appState: AppState!
    private var viewModel: HomeViewModel!

    override func setUp() {
        super.setUp()
        router = AppRouterMock()
        persistenceMock = PersistenceServiceMock()
        persistence = StoryPersistence(service: persistenceMock)
        appState = AppState()
        viewModel = HomeViewModel(
            service: StoryServiceMock(),
            persistence: persistence,
            router: router,
            appState: appState
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

    func testLoadStories_shouldPopulateAppState() async {
        viewModel.loadStories()
        XCTAssertFalse(appState.stories.isEmpty)
    }

    func testSelectStory_shouldPresentSheet() {
        appState.stories = StoryServiceMock.mockStories
        viewModel.selectStory(at: 0)
        XCTAssertNotNil(router.presentedSheet)
    }

    func testIsStorySeen_whenNoItemsSeen_shouldReturnFalse() {
        let story = StoryServiceMock.mockStories[0]
        XCTAssertFalse(viewModel.isStorySeen(story))
    }

    func testIsStorySeen_whenAllItemsSeen_shouldReturnTrue() {
        let story = StoryServiceMock.mockStories[0]
        story.items.forEach { persistence.state.seenItemIds.insert($0.imageURL) }
        XCTAssertTrue(viewModel.isStorySeen(story))
    }

    func testLoadMoreStories_shouldAppendNewStories() {
        appState.stories = StoryServiceMock.mockStories
        let initialCount = appState.stories.count
        viewModel.loadMoreStories()
        XCTAssertGreaterThan(appState.stories.count, initialCount)
    }

    func testLoadMoreStories_whenAlreadyLoading_shouldNotLoadAgain() {
        appState.stories = StoryServiceMock.mockStories
        appState.isLoadingMorePage = true
        let initialCount = appState.stories.count
        viewModel.loadMoreStories()
        XCTAssertEqual(appState.stories.count, initialCount)
    }

    func testLoadMoreStories_newStoriesShouldHaveDifferentIds() {
        appState.stories = StoryServiceMock.mockStories
        let originalIds = Set(appState.stories.map { $0.user.id })
        viewModel.loadMoreStories()
        let newStories = appState.stories.filter { !originalIds.contains($0.user.id) }
        XCTAssertFalse(newStories.isEmpty)
    }

    func testLoadMoreStoriesIfNeeded_whenFarFromEnd_shouldNotLoad() {
        appState.stories = StoryServiceMock.mockStories
        let initialCount = appState.stories.count
        let firstStory = appState.stories[0]
        viewModel.loadMoreStoriesIfNeeded(currentStory: firstStory)
        XCTAssertEqual(appState.stories.count, initialCount)
    }

    func testLoadMoreStoriesIfNeeded_whenCloseToEnd_shouldLoadMore() {
        appState.stories = StoryServiceMock.mockStories
        let initialCount = appState.stories.count
        let lastStory = appState.stories[appState.stories.count - 3]
        viewModel.loadMoreStoriesIfNeeded(currentStory: lastStory)
        XCTAssertGreaterThan(appState.stories.count, initialCount)
    }

    func testIsStorySeen_whenOnlySomeItemsSeen_shouldReturnFalse() {
        let story = StoryServiceMock.mockStories[0]
        persistence.state.seenItemIds.insert(story.items[0].imageURL)
        XCTAssertFalse(viewModel.isStorySeen(story))
    }

    func testIndexOfStory_shouldReturnCorrectIndex() {
        appState.stories = StoryServiceMock.mockStories
        let story = appState.stories[1]
        XCTAssertEqual(viewModel.index(of: story), 1)
    }

    func testIndexOfStory_whenNotFound_shouldReturnNil() {
        appState.stories = StoryServiceMock.mockStories
        let unknownStory = Story(
            user: User(id: "unknown", name: "unknown", avatarURL: "", isCurrent: false),
            items: []
        )
        XCTAssertNil(viewModel.index(of: unknownStory))
    }

    func testSelectStory_shouldPresentSheetWithCorrectIndex() {
        appState.stories = StoryServiceMock.mockStories
        viewModel.selectStory(at: 1)
        XCTAssertEqual(router.presentedSheet, .story(startIndex: 1))
    }
}
