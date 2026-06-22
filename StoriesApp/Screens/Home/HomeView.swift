//
//  HomeView.swift
//  StoriesApp
//
//  Created by Pauline Nomballais on 15/06/2026.
//

import SwiftUI

struct HomeView: View {

    @State private var viewModel: HomeViewModel
    @State private var showAddStoryAlert = false
    @State private var showNotificationsAlert = false

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            homeHeader
            storiesList
            homeFeed
        }
        .background(StoriesColor.Feed.background)
        .task {
            await viewModel.loadStories()
        }
        .onChange(of: viewModel.appState.shouldLoadMorePage) { _, shouldLoad in
            if shouldLoad {
                Task {
                    await viewModel.loadMoreStories()
                    viewModel.appState.shouldLoadMorePage = false
                }
            }
        }
        .errorAlert(
            isPresented: $viewModel.showErrorAlert,
            error: viewModel.appState.error,
            onRetry: {
                Task {
                    await viewModel.loadStories()
                }
            }
        )
    }

    private var homeHeader: some View {
        HStack {
            Button {
                showAddStoryAlert = true
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 22, weight: .light))
                    .foregroundColor(StoriesColor.Home.headerIcon)
            }
            .featureComingSoonAlert(isPresented: $showAddStoryAlert)

            Spacer()

            Text("StoriesApp")
                .font(.system(size: 22, weight: .semibold))

            Spacer()

            Button {
                showNotificationsAlert = true
            } label: {
                Image(systemName: "heart")
                    .font(.system(size: 22, weight: .light))
                    .foregroundColor(StoriesColor.Home.headerIcon)
            }
            .featureComingSoonAlert(isPresented: $showNotificationsAlert)
        }
        .padding(.horizontal, .space2w)
        .padding(.vertical, .space1w)
    }

    private var storiesList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 12) {
                ForEach(viewModel.stories, id: \.id) { story in
                    StoryAvatarView(
                        story: story,
                        isSeen: viewModel.isStorySeen(story)
                    )
                    .accessibilityElement(children: .combine)
                    .accessibilityIdentifier("story_avatar_\(story.user.id)")
                    .onTapGesture {
                        if let index = viewModel.index(of: story) {
                            viewModel.selectStory(at: index)
                        }
                    }
                    .task {
                        await viewModel.loadMoreStoriesIfNeeded(currentStory: story)
                    }
                }
            }
            .padding(.space1w)
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
