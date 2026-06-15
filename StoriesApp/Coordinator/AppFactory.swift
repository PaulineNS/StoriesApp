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

    func makeHomeView(router: AppRouter) -> some View {
        HomeView(
            viewModel: HomeViewModel(
                service: StoryService(),
                persistence: persistence,
                router: router
            )
        )
    }

    func makeStoryView(
        stories: [Story],
        startIndex: Int,
        router: AppRouter
    ) -> some View {
        StoryView(
            viewModel: StoryViewModel(
                router: router,
                persistence: persistence,
                stories: stories,
                startIndex: startIndex
            )
        )
    }
}
