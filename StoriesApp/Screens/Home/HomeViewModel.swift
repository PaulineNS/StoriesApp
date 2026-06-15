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

    private var currentPage = 0

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

    func loadMoreStoriesIfNeeded(currentStory: Story) {
        guard let index = stories.firstIndex(where: { $0.user.id == currentStory.user.id }) else { return }
        if index >= stories.count - 5 {
            loadMoreStories()
        }
    }

    private func loadMoreStories() {
        guard let baseStories = try? service.fetchStories() else { return }
        currentPage += 1
        let newStories = baseStories
            .filter { !$0.user.isCurrent }
            .map { story in
                Story(
                    user: User(
                        id: "\(story.user.id)-page\(currentPage)",
                        name: story.user.name,
                        avatarURL: story.user.avatarURL,
                        isCurrent: false
                    ),
                    items: story.items.map { item in
                        StoryItem(imageURL: "\(item.imageURL)?page=\(currentPage)")
                    }
                )
            }
        stories.append(contentsOf: newStories)
    }
}
