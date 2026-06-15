//
//  StoryService.swift
//  StoriesApp
//
//  Created by Pauline Nomballais on 15/06/2026.
//

import Foundation

protocol StoryServiceProtocol {
    func fetchStories() throws -> [StoryGroup]
}

final class StoryService: StoryServiceProtocol {
    func fetchStories() throws -> [StoryGroup] {
        guard let url = Bundle.main.url(forResource: "stories", withExtension: "json") else {
            throw StoryError.fileNotFound
        }
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let decoded = try decoder.decode(StoriesResponse.self, from: data)
        return decoded.stories
    }
}

private struct StoriesResponse: Codable {
    let stories: [StoryGroup]
}

enum StoryError: Error {
    case fileNotFound
}
