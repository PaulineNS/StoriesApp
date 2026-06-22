//
//  HomeViewModel.swift
//  StoriesApp
//
//  Created by Pauline Nomballais on 15/06/2026.
//

import Foundation

@Observable
@MainActor
final class HomeViewModel {

    // MARK: - Properties

    private let fetchStoriesUseCase: FetchStoriesUseCaseProtocol
    private let loadMoreStoriesUseCase: LoadMoreStoriesUseCaseProtocol
    private let persistence: StoryPersistence
    private let router: AppRouter
    let appState: AppState

    // MARK: - Init

    init(
        fetchStoriesUseCase: FetchStoriesUseCaseProtocol,
        loadMoreStoriesUseCase: LoadMoreStoriesUseCaseProtocol,
        persistence: StoryPersistence,
        router: AppRouter,
        appState: AppState
    ) {
        self.fetchStoriesUseCase = fetchStoriesUseCase
        self.loadMoreStoriesUseCase = loadMoreStoriesUseCase
        self.persistence = persistence
        self.router = router
        self.appState = appState
    }

    // MARK: - Computed Properties

    var stories: [Story] { appState.stories }

    var showErrorAlert: Bool {
        get { appState.showErrorAlert }
        set { appState.showErrorAlert = newValue }
    }

    // MARK: - Stories

    func loadStories() async {
        do {
            appState.stories = try await fetchStoriesUseCase.execute()
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

    // MARK: - Pagination

    func loadMoreStoriesIfNeeded(currentStory: Story) async {
        guard let index = appState.stories.firstIndex(where: { $0.id == currentStory.id }) else { return }
        if index >= appState.stories.count - 5 {
            await loadMoreStories()
        }
    }

    func loadMoreStories() async {
        guard !appState.isLoadingMorePage else { return }
        appState.isLoadingMorePage = true
        do {
            appState.currentPage += 1
            let newStories = try await loadMoreStoriesUseCase.execute(currentPage: appState.currentPage)
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
}
