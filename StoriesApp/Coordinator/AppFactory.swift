//
//  AppFactory.swift
//  StoriesApp
//
//  Created by Pauline Nomballais on 15/06/2026.
//

import SwiftUI

@MainActor
final class AppFactory {

    private let persistence = StoryPersistence()
    private let appState = AppState()
    private let repository: StoryRepositoryProtocol = StoryRepository()

    func makeHomeView(router: AppRouter) -> some View {
        HomeView(
            viewModel: HomeViewModel(
                fetchStoriesUseCase: FetchStoriesUseCase(repository: repository),
                loadMoreStoriesUseCase: LoadMoreStoriesUseCase(repository: repository),
                persistence: persistence,
                router: router,
                appState: appState
            )
        )
    }

    func makeStoryView(router: AppRouter, startIndex: Int) -> some View {
        StoryView(
            viewModel: StoryViewModel(
                router: router,
                toggleLikeUseCase: ToggleLikeUseCase(repository: persistence),
                markStorySeenUseCase: MarkStorySeenUseCase(repository: persistence),
                persistenceRepository: persistence,
                appState: appState,
                startIndex: startIndex
            )
        )
    }
}
