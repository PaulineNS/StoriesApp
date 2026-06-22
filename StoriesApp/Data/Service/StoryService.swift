//
//  StoryService.swift
//  StoriesApp
//
//  Created by Pauline Nomballais on 15/06/2026.
//

import Foundation

protocol StoryServiceProtocol {
    func fetchStories() async throws -> [Story]
}

final class StoryService: StoryServiceProtocol {
    func fetchStories() async throws -> [Story] {
        try await Task.detached(priority: .userInitiated) {
            guard let url = Bundle.main.url(forResource: "stories", withExtension: "json") else {
                throw StoryError.fileNotFound
            }
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let decoded = try decoder.decode(StoriesResponse.self, from: data)
            return decoded.stories
        }.value
    }
}

private struct StoriesResponse: Codable, Sendable {
    let stories: [Story]
}
