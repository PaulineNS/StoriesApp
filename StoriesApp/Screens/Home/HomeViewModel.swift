//
//  HomeViewModel.swift
//  StoriesApp
//
//  Created by Pauline Nomballais on 15/06/2026.
//

import Foundation

@Observable
final class HomeViewModel {

    private let service: StoryServiceProtocol
    private let persistence: StoryPersistence
    private let router: AppRouter

    let appState: AppState

    init(
        service: StoryServiceProtocol = StoryService(),
        persistence: StoryPersistence,
        router: AppRouter,
        appState: AppState
    ) {
        self.service = service
        self.persistence = persistence
        self.router = router
        self.appState = appState
    }

    var stories: [Story] { appState.stories }

    var showErrorAlert: Bool {
        get { appState.showErrorAlert }
        set { appState.showErrorAlert = newValue }
    }

    @MainActor
    func loadStories() {
        do {
            appState.stories = try service.fetchStories()
        } catch let error as StoryError {
            appState.error = error
            appState.showErrorAlert = true
        } catch {
            appState.error = .unknown
            appState.showErrorAlert = true
        }
    }

    func selectStory(at index: Int) {
        router.present(sheet: .story(startIndex: index))
    }

    func index(of story: Story) -> Int? {
        appState.stories.firstIndex(where: { $0.id == story.id })
    }

    func isStorySeen(_ story: Story) -> Bool {
        story.items.allSatisfy { persistence.state.seenItemIds.contains($0.imageURL) }
    }

    func loadMoreStoriesIfNeeded(currentStory: Story) {
        guard let index = appState.stories.firstIndex(where: { $0.id == currentStory.id }) else { return }
        if index >= appState.stories.count - 5 {
            loadMoreStories()
        }
    }

    func loadMoreStories() {
        guard !appState.isLoadingMorePage else { return }
        appState.isLoadingMorePage = true
        do {
            let baseStories = try service.fetchStories()
            appState.currentPage += 1
            let newStories = makeNewStories(from: baseStories)
            appState.stories.append(contentsOf: newStories)
        } catch let error as StoryError {
            appState.error = error
            appState.showErrorAlert = true
        } catch {
            appState.error = .unknown
            appState.showErrorAlert = true
        }
        appState.isLoadingMorePage = false
    }

    private func makeNewStories(from baseStories: [Story]) -> [Story] {
        baseStories
            .filter { !$0.user.isCurrent }
            .map { story in
                Story(
                    id: "\(story.id)-page\(appState.currentPage)",
                    user: User(
                        id: "\(story.user.id)-page\(appState.currentPage)",
                        name: story.user.name,
                        avatarURL: story.user.avatarURL,
                        isCurrent: false
                    ),
                    items: story.items.map { item in
                        StoryItem(imageURL: "\(item.imageURL)?page=\(appState.currentPage)")
                    }
                )
            }
    }
}
