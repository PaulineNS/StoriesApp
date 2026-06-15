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

    init(viewModel: StoryViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 12) {
                ZStack {
                    Color.black.ignoresSafeArea()
                    storyImage(width: geo.size.width, height: geo.size.height * 0.90)
                    tapZones
                    VStack {
                        header
                        Spacer()
                    }
                }
                .frame(height: geo.size.height * 0.90)

                footer
                    .frame(height: geo.size.height * 0.10)
                    .background(Color.black)
            }
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
                Color(.systemGray6)
            @unknown default:
                Color(.systemGray6)
            }
        }
        .frame(width: width, height: height)
        .clipped()
        .clipShape(RoundedRectangle(cornerRadius: 12))
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
        .padding(8)
    }

    private var progressBars: some View {
        HStack(spacing: 2) {
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
        Text(viewModel.currentStory.user.isCurrent ? "Your story" : viewModel.currentStory.user.name)
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(.white)
    }

    private var dismissButton: some View {
        Button {
            viewModel.dismiss()
        } label: {
            Image(systemName: "xmark")
                .font(.system(size: 25, weight: .light))
                .foregroundColor(.white)
        }
    }

    private var footer: some View {
        HStack(spacing: 16) {
            messageTextfield
            likeButton
            shareButton
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 32)
    }

    private var messageTextfield: some View {
        TextField("Send message...", text: .constant(""))
            .disabled(true)
            .foregroundColor(.white.opacity(0.8))
            .font(.system(size: 15))
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(Color.white.opacity(0.5), lineWidth: 1)
            )
    }

    private var likeButton: some View {
        Button {
            viewModel.toggleLikeCurrentItem()
        } label: {
            Image(systemName: viewModel.isCurrentItemLiked() ? "heart.fill" : "heart")
                .font(.system(size: 28))
                .foregroundColor(viewModel.isCurrentItemLiked() ? .red : .white)
        }
    }

    private var shareButton: some View {
        Button {
            showShareAlert = true
        } label: {
            Image(systemName: "paperplane")
                .font(.system(size: 24))
                .foregroundColor(.white)
        }
        .alert("Feature coming soon", isPresented: $showShareAlert) {
            Button("OK", role: .cancel) {}
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
                    if horizontal < -50 {
                        slideDirection = .trailing
                        viewModel.navigateToStory(direction: .next)
                    } else if horizontal > 50 {
                        slideDirection = .leading
                        viewModel.navigateToStory(direction: .previous)
                    }
                } else if vertical > 150 {
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
