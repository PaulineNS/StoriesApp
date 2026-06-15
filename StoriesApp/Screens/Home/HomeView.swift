//
//  HomeView.swift
//  StoriesApp
//
//  Created by Pauline Nomballais on 15/06/2026.
//

import SwiftUI

struct HomeView: View {

    @State private var viewModel: HomeViewModel

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            storiesList
            homeFeed
        }
        .background(Color(.systemBackground))
        .onAppear {
            viewModel.loadStories()
        }
        .onChange(of: viewModel.appState.shouldLoadMorePage) { _, shouldLoad in
            if shouldLoad {
                viewModel.loadMoreStories()
                viewModel.appState.shouldLoadMorePage = false
            }
        }
    }

    private var storiesList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 12) {
                ForEach(viewModel.appState.stories, id: \.user.id) { story in
                    StoryAvatarView(
                        story: story,
                        isSeen: viewModel.isStorySeen(story)
                    )
                    .onTapGesture {
                        if let index = viewModel.index(of: story) {
                            viewModel.selectStory(at: index)
                        }
                    }
                    .onAppear {
                        viewModel.loadMoreStoriesIfNeeded(currentStory: story)
                    }
                }
            }
            .padding(8)
        }
    }

    private var homeFeed: some View {
        LazyVStack(spacing: 12) {
            ForEach(0..<10, id: \.self) { _ in
                SkeletonPostView()
            }
        }
    }
}

#Preview {
    let router = AppRouterImpl()
    let factory = AppFactory()
    return factory.makeHomeView(router: router)
}
