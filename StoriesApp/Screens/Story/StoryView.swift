//
//  StoryView.swift
//  StoriesApp
//
//  Created by Pauline Nomballais on 15/06/2026.
//

import SwiftUI

struct StoryView: View {

    @State private var viewModel: StoryViewModel
    @State private var showShareAlert = false
    @State private var dragOffset: CGFloat = 0
    @State private var slideDirection: Edge = .trailing

    private let storyImageHeightRatio: CGFloat = 0.90
    private let footerHeightRatio: CGFloat = 0.10
    private let swipeThreshold: CGFloat = 150
    private let horizontalSwipeThreshold: CGFloat = 50

    init(viewModel: StoryViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 12) {
                ZStack {
                    StoriesColor.Story.background.ignoresSafeArea()
                    storyImage(width: geo.size.width, height: geo.size.height * storyImageHeightRatio)
                    tapZones
                    VStack {
                        header
                        Spacer()
                    }
                }
                .frame(height: geo.size.height * storyImageHeightRatio)

                footer
                    .frame(height: geo.size.height * footerHeightRatio)
                    .background(StoriesColor.Story.background)
            }
            .background(StoriesColor.Story.background)
            .offset(y: dragOffset)
            .gesture(dragGesture)
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
                StoriesColor.Story.background
                    .onAppear {
                        viewModel.startTimer()
                    }
            @unknown default:
                StoriesColor.Story.background
                    .onAppear {
                        viewModel.startTimer()
                    }
            }
        }
        .frame(width: width, height: height)
        .clipped()
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.s.value))
        .id("\(viewModel.currentStory.user.id)-\(viewModel.currentStoryItem.imageURL)")
        .transition(.move(edge: slideDirection))
        .animation(.easeInOut(duration: 0.3), value: viewModel.currentStory.user.id)
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
        .padding(.space1w)
    }

    private var progressBars: some View {
        HStack(spacing: 2) {
            ForEach(0..<viewModel.currentStory.items.count, id: \.self) { index in
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: CornerRadius.xxs.value)
                            .fill(StoriesColor.Story.progressBackground)
                            .frame(height: 2)

                        RoundedRectangle(cornerRadius: CornerRadius.xxs.value)
                            .fill(StoriesColor.Story.progressFill)
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
            StoriesColor.Feed.skeleton
        }
        .frame(width: 32, height: 32)
        .clipShape(Circle())
    }

    private var userLabel: some View {
        Text(viewModel.currentStory.user.isCurrent ? "Your story" : viewModel.currentStory.user.name)
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(StoriesColor.Story.text)
    }

    private var dismissButton: some View {
        Button {
            viewModel.dismiss()
        } label: {
            Image(systemName: "xmark")
                .font(.system(size: 25, weight: .light))
                .foregroundColor(StoriesColor.Story.icon)
        }
        .accessibilityIdentifier("dismiss_button")
    }

    private var footer: some View {
        HStack(spacing: 16) {
            messageTextfield
            likeButton
            shareButton
        }
        .padding(.horizontal, .space2w)
        .padding(.bottom, .space4w)
    }

    private var messageTextfield: some View {
        Text("Send message...")
            .foregroundColor(StoriesColor.Story.textSecondary)
            .font(.system(size: 15))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, .space2w)
            .padding(.vertical, .space3v)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.m.value)
                    .stroke(StoriesColor.Story.messageBorder, lineWidth: 1)
            )
    }

    private var likeButton: some View {
        Button {
            viewModel.toggleLikeCurrentItem()
        } label: {
            Image(systemName: viewModel.isCurrentItemLiked ? "heart.fill" : "heart")
                .font(.system(size: 28))
                .foregroundColor(viewModel.isCurrentItemLiked ? StoriesColor.Story.like : StoriesColor.Story.progressFill)
        }
        .accessibilityIdentifier("like_button")
    }

    private var shareButton: some View {
        Button {
            showShareAlert = true
        } label: {
            Image(systemName: "paperplane")
                .font(.system(size: 24))
                .foregroundColor(StoriesColor.Story.icon)
        }
        .featureComingSoonAlert(isPresented: $showShareAlert)
    }

    private var tapZones: some View {
        HStack(spacing: 0) {
            StoriesColor.Story.tapZone
                .contentShape(Rectangle())
                .onTapGesture { viewModel.goToPreviousItem() }
                .pauseOnLongPress(
                    stopTimer: { viewModel.stopTimer() },
                    startTimer: { viewModel.startTimer() }
                )

            StoriesColor.Story.tapZone
                .contentShape(Rectangle())
                .onTapGesture { viewModel.goToNextItem() }
                .pauseOnLongPress(
                    stopTimer: { viewModel.stopTimer() },
                    startTimer: { viewModel.startTimer() }
                )
        }
    }

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                if value.translation.height > 0 && abs(value.translation.height) > abs(value.translation.width) {
                    dragOffset = value.translation.height
                }
            }
            .onEnded { value in
                let horizontal = value.translation.width
                let vertical = value.translation.height

                if abs(horizontal) > abs(vertical) {
                    if horizontal < -horizontalSwipeThreshold {
                        slideDirection = .trailing
                        viewModel.navigateToStory(direction: .next)
                    } else if horizontal > horizontalSwipeThreshold {
                        slideDirection = .leading
                        viewModel.navigateToStory(direction: .previous)
                    }
                } else if vertical > swipeThreshold {
                    viewModel.dismiss()
                } else {
                    withAnimation(.spring()) {
                        dragOffset = 0
                    }
                }
            }
    }
}

#Preview {
    let router = AppRouterImpl()
    let factory = AppFactory()
    return factory.makeStoryView(router: router, startIndex: 0)
}
