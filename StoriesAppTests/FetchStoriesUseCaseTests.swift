//
//  FetchStoriesUseCaseTests.swift
//  StoriesAppTests
//
//  Created by Pauline Nomballais on 22/06/2026.
//

import XCTest
@testable import StoriesApp

@MainActor
final class FetchStoriesUseCaseTests: XCTestCase {

    private var repositoryMock: StoryRepositoryMock!
    private var useCase: FetchStoriesUseCase!

    override func setUp() {
        super.setUp()
        repositoryMock = StoryRepositoryMock()
        useCase = FetchStoriesUseCase(repository: repositoryMock)
    }

    override func tearDown() {
        repositoryMock = nil
        useCase = nil
        super.tearDown()
    }

    func testExecute_shouldReturnStoriesFromRepository() async throws {
        repositoryMock.storiesToReturn = StoryServiceMock.mockStories
        let result = try await useCase.execute()
        XCTAssertEqual(result.count, StoryServiceMock.mockStories.count)
    }

    func testExecute_whenRepositoryThrows_shouldPropagateError() async {
        repositoryMock.errorToThrow = StoryError.fileNotFound
        do {
            _ = try await useCase.execute()
            XCTFail("Expected an error to be thrown")
        } catch {
            XCTAssertEqual(error as? StoryError, .fileNotFound)
        }
    }

    func testExecute_shouldCallRepositoryExactlyOnce() async throws {
        repositoryMock.storiesToReturn = StoryServiceMock.mockStories
        _ = try await useCase.execute()
        XCTAssertEqual(repositoryMock.fetchStoriesCallCount, 1)
    }
}
