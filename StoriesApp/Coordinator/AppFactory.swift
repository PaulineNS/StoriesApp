//
//  AppFactory.swift
//  StoriesApp
//
//  Created by Pauline Nomballais on 15/06/2026.
//

import SwiftUI

@MainActor
final class AppFactory {

    func makeHomeView(router: AppRouter) -> some View {
        HomeView(viewModel: HomeViewModel(service: StoryService(), router: router))
    }

    func makeStoryView(stories: [Story], startIndex: Int, router: AppRouter) -> some View {
        StoryView(
            viewModel: StoryViewModel(
                router: router,
                stories: stories,
                startIndex: startIndex
            )
        )
    }
}
