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
    private let router: AppRouter

    init(
        service: StoryServiceProtocol = StoryService(),
        router: AppRouter
    ) {
        self.service = service
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
}
