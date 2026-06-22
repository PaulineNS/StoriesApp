//
//  FetchStoriesUseCase.swift
//  StoriesApp
//
//  Created by Pauline Nomballais on 22/06/2026.
//

import Foundation

protocol FetchStoriesUseCaseProtocol {
    func execute() async throws -> [Story]
}

final class FetchStoriesUseCase: FetchStoriesUseCaseProtocol {

    private let repository: StoryRepositoryProtocol

    init(repository: StoryRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> [Story] {
        try await repository.fetchStories()
    }
}
