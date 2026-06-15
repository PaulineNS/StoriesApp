//
//  StoryAvatarView.swift
//  StoriesApp
//
//  Created by Pauline Nomballais on 15/06/2026.
//

import SwiftUI

struct StoryAvatarView: View {

    let story: Story

    var body: some View {
        VStack(spacing: 6) {
            ZStack(alignment: .bottomTrailing) {
                avatarImage
                if story.user.isCurrent {
                    plusButton
                }
            }
            label
        }
        .frame(width: 72)
    }

    private var avatarImage: some View {
        AsyncImage(url: URL(string: story.user.avatarURL)) { image in
            image
                .resizable()
                .scaledToFill()
        } placeholder: {
            Color(.systemGray6)
        }
        .frame(width: 66, height: 66)
        .clipShape(Circle())
        .padding(5)
        .overlay(
            Circle()
                .stroke(LinearGradient(
                    colors: [.yellow, .orange, .pink, .purple],
                    startPoint: .bottomLeading,
                    endPoint: .topTrailing
                ), lineWidth: 3.5)
                .opacity(story.items.isEmpty ? 0 : 1)
        )
    }

    private var plusButton: some View {
        ZStack {
            Circle()
                .foregroundColor(Color(.systemBackground))
                .frame(width: 26, height: 26)
            Circle()
                .foregroundColor(Color(.label))
                .frame(width: 22, height: 22)
            Image(systemName: "plus")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(Color(.systemBackground))
        }
        .offset(x: -2, y: -2)
    }

    private var label: some View {
        Text(story.user.isCurrent ? "Your story" : story.user.name)
            .font(.system(size: 12))
            .lineLimit(1)
            .foregroundColor(.primary)
    }
}

#Preview {
    StoryAvatarView(story: Story(
        user: User(id: "user-1", name: "camillette", avatarURL: "https://randomuser.me/api/portraits/women/1.jpg", isCurrent: true),
        items: [
            StoryItem(imageURL: "https://picsum.photos/seed/camillette1/800/1400")
        ]
    ))
}
