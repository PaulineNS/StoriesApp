//
//  LoadMoreStoriesUseCase.swift
//  StoriesApp
//
//  Created by Pauline Nomballais on 22/06/2026.
//

import Foundation

protocol LoadMoreStoriesUseCaseProtocol {
    func execute(currentPage: Int) async throws -> [Story]
}

final class LoadMoreStoriesUseCase: LoadMoreStoriesUseCaseProtocol {

    private let repository: StoryRepositoryProtocol

    init(repository: StoryRepositoryProtocol) {
        self.repository = repository
    }

    func execute(currentPage: Int) async throws -> [Story] {
        let baseStories = try await repository.fetchStories()
        return makeNewStories(from: baseStories, page: currentPage)
    }

    private func makeNewStories(from baseStories: [Story], page: Int) -> [Story] {
        baseStories
            .filter { !$0.user.isCurrent }
            .map { story in
                Story(
                    id: "\(story.id)-page\(page)",
                    user: User(
                        id: "\(story.user.id)-page\(page)",
                        name: story.user.name,
                        avatarURL: story.user.avatarURL,
                        isCurrent: false
                    ),
                    items: story.items.map { item in
                        StoryItem(imageURL: "\(item.imageURL)?page=\(page)")
                    }
                )
            }
    }
}
