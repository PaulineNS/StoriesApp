//
//  HomeView.swift
//  StoriesApp
//
//  Created by Pauline Nomballais on 15/06/2026.
//

import SwiftUI

struct HomeView: View {

    @State private var viewModel: HomeViewModel

    init(viewModel: HomeViewModel = HomeViewModel()) {
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
    }

    private var storiesList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 12) {
                ForEach(viewModel.stories, id: \.user.id) { story in
                    StoryAvatarView(story: story)
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
    HomeView(viewModel: HomeViewModel(service: StoryServiceMock()))
}
