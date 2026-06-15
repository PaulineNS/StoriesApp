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

    func makeHomeView(router: AppRouter) -> some View {
        HomeView(
            viewModel: HomeViewModel(
                service: StoryService(),
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
                persistence: persistence,
                appState: appState,
                startIndex: startIndex
            )
        )
    }
}
