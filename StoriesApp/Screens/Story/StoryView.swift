//
//  StoryView.swift
//  StoriesApp
//
//  Created by Pauline Nomballais on 15/06/2026.
//

import SwiftUI

struct StoryView: View {

    @State private var viewModel: StoryViewModel

    init(viewModel: StoryViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.black.ignoresSafeArea()

                storyImage(width: geo.size.width, height: geo.size.height)

                tapZones

                VStack {
                    header
                    Spacer()
                }
            }
        }
        .onDisappear {
            viewModel.stopTimer()
        }
    }

    private func storyImage(width: CGFloat, height: CGFloat) -> some View {
        AsyncImage(url: URL(string: viewModel.currentStoryItem.imageURL)) { response in
            switch response {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .onAppear {
                        viewModel.startTimer()
                    }
            case .empty, .failure:
                Color(.systemGray6)
            @unknown default:
                Color(.systemGray6)
            }
        }
        .id(viewModel.currentStoryItem.imageURL)
        .frame(width: width, height: height)
        .clipped()
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var header: some View {
        VStack(spacing: 8) {
            progressBars

            HStack {
                userAvatar
                userLabel
                Spacer()
                dismissButton
            }
        }
        .padding(8)
    }

    private var progressBars: some View {
        HStack(spacing: 4) {
            ForEach(0..<viewModel.currentStory.items.count, id: \.self) { index in
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.white.opacity(0.4))
                            .frame(height: 2)

                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.white)
                            .frame(width: viewModel.progressBarWidth(for: index, totalWidth: geo.size.width), height: 2)
                    }
                }
                .frame(height: 2)
            }
        }
    }

    private var userAvatar: some View {
        AsyncImage(url: URL(string: viewModel.currentStory.user.avatarURL)) { image in
            image
                .resizable()
                .scaledToFill()
        } placeholder: {
            Color(.systemGray6)
        }
        .frame(width: 32, height: 32)
        .clipShape(Circle())
    }

    private var userLabel: some View {
        Text(viewModel.currentStory.user.name)
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(.white)
    }

    private var dismissButton: some View {
        Button {
            viewModel.dismiss()
        } label: {
            Image(systemName: "xmark")
                .font(.system(size: 20, weight: .regular))
                .foregroundColor(.white)
        }
    }

    private var tapZones: some View {
        HStack(spacing: 0) {
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.goToPreviousItem()
                }

            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.goToNextItem()
                }
        }
    }
}

#Preview {
    let router = AppRouterImpl()
    let factory = AppFactory()
    return factory.makeStoryView(stories: StoryServiceMock.mockStories, startIndex: 0, router: router)
}
