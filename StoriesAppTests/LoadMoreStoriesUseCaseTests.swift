//
//  LoadMoreStoriesUseCaseTests.swift
//  StoriesAppTests
//
//  Created by Pauline Nomballais on 22/06/2026.
//

import XCTest
@testable import StoriesApp

@MainActor
final class LoadMoreStoriesUseCaseTests: XCTestCase {

    private var repositoryMock: StoryRepositoryMock!
    private var useCase: LoadMoreStoriesUseCase!

    override func setUp() {
        super.setUp()
        repositoryMock = StoryRepositoryMock()
        useCase = LoadMoreStoriesUseCase(repository: repositoryMock)
    }

    override func tearDown() {
        repositoryMock = nil
        useCase = nil
        super.tearDown()
    }

    func testExecute_shouldReturnStoriesWithUniqueIdsForPage() async throws {
        repositoryMock.storiesToReturn = StoryServiceMock.mockStories
        let result = try await useCase.execute(currentPage: 1)

        for story in result {
            XCTAssertTrue(story.id.hasSuffix("-page1"))
            XCTAssertTrue(story.user.id.hasSuffix("-page1"))
        }
    }

    func testExecute_shouldExcludeCurrentUserStory() async throws {
        repositoryMock.storiesToReturn = StoryServiceMock.mockStories
        let result = try await useCase.execute(currentPage: 1)

        XCTAssertFalse(result.contains(where: { $0.user.isCurrent }))
    }

    func testExecute_shouldAppendPageQueryToImageURLs() async throws {
        repositoryMock.storiesToReturn = StoryServiceMock.mockStories
        let result = try await useCase.execute(currentPage: 2)

        let allItems = result.flatMap { $0.items }
        for item in allItems {
            XCTAssertTrue(item.imageURL.contains("?page=2"))
        }
    }

    func testExecute_differentPages_shouldProduceDifferentIds() async throws {
        repositoryMock.storiesToReturn = StoryServiceMock.mockStories
        let page1Result = try await useCase.execute(currentPage: 1)
        let page2Result = try await useCase.execute(currentPage: 2)

        let page1Ids = Set(page1Result.map { $0.id })
        let page2Ids = Set(page2Result.map { $0.id })
        XCTAssertTrue(page1Ids.isDisjoint(with: page2Ids))
    }

    func testExecute_whenRepositoryThrows_shouldPropagateError() async {
        repositoryMock.errorToThrow = StoryError.unknown
        do {
            _ = try await useCase.execute(currentPage: 1)
            XCTFail("Expected an error to be thrown")
        } catch {
            XCTAssertEqual(error as? StoryError, .unknown)
        }
    }
}
