//
//  HomeViewModel.swift
//  StoriesApp
//
//  Created by Pauline Nomballais on 15/06/2026.
//

import Foundation

@Observable
final class HomeViewModel {

    private(set) var stories: [Story] = []

    private let service: StoryServiceProtocol
    private let persistence: StoryPersistence
    private let router: AppRouter

    init(
        service: StoryServiceProtocol = StoryService(),
        persistence: StoryPersistence,
        router: AppRouter
    ) {
        self.service = service
        self.persistence = persistence
        self.router = router
    }

    @MainActor
    func loadStories() {
        do {
            stories = try service.fetchStories()
        } catch {
            print("Failed to load stories: \(error)")
        }
    }

    func selectStory(at index: Int) {
        router.present(sheet: .story(stories: stories, startIndex: index))
    }

    func index(of story: Story) -> Int? {
        stories.firstIndex(where: { $0.user.id == story.user.id })
    }

    func isStorySeen(_ story: Story) -> Bool {
        story.items.allSatisfy { persistence.state.seenItemIds.contains($0.imageURL) }
    }
}
