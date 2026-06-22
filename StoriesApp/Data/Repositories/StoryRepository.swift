//
//  StoryRepository.swift
//  StoriesApp
//
//  Created by Pauline Nomballais on 22/06/2026.
//

import Foundation

final class StoryRepository: StoryRepositoryProtocol {

    private let service: StoryServiceProtocol

    init(service: StoryServiceProtocol = StoryService()) {
        self.service = service
    }

    func fetchStories() async throws -> [Story] {
        try await service.fetchStories()
    }
}
