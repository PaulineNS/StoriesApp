//
//  StoryRepositoryMock.swift
//  StoriesAppTests
//
//  Created by Pauline Nomballais on 22/06/2026.
//

import Foundation
@testable import StoriesApp

final class StoryRepositoryMock: StoryRepositoryProtocol {

    var storiesToReturn: [Story] = []
    var errorToThrow: Error?
    var fetchStoriesCallCount = 0

    func fetchStories() async throws -> [Story] {
        fetchStoriesCallCount += 1
        if let errorToThrow {
            throw errorToThrow
        }
        return storiesToReturn
    }
}
