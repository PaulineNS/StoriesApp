//
//  StoryAvatarView.swift
//  StoriesApp
//
//  Created by Pauline Nomballais on 15/06/2026.
//

import SwiftUI

struct StoryAvatarView: View {

    let story: Story
    var isSeen: Bool = false

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
        .frame(width: 90)
    }

    private var avatarImage: some View {
        AsyncImage(url: URL(string: story.user.avatarURL)) { image in
            image
                .resizable()
                .scaledToFill()
        } placeholder: {
            StoriesColor.Feed.skeleton
        }
        .frame(width: 80, height: 80)
        .clipShape(Circle())
        .padding(.space1v)
        .overlay(
            Circle()
                .stroke(ringStyle, lineWidth: 3.5)
                .opacity(story.items.isEmpty ? 0 : 1)
        )
    }

    private var plusButton: some View {
        ZStack {
            Circle()
                .foregroundColor(StoriesColor.Feed.background)
                .frame(width: 26, height: 26)
            Circle()
                .foregroundColor(StoriesColor.Avatar.plusButtonForeground)
                .frame(width: 22, height: 22)
            Image(systemName: "plus")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(StoriesColor.Feed.background)
        }
        .offset(x: -2, y: -2)
    }

    private var label: some View {
        Text(story.user.isCurrent ? "Your story" : story.user.name)
            .font(.system(size: 12))
            .lineLimit(1)
            .foregroundColor(StoriesColor.Avatar.labelText)
    }

    private var ringStyle: AnyShapeStyle {
        if isSeen {
            return AnyShapeStyle(StoriesColor.Feed.skeleton)
        } else {
            return AnyShapeStyle(LinearGradient(
                colors: [
                    StoriesColor.Ring.gradientStart,
                    StoriesColor.Ring.gradientMiddle1,
                    StoriesColor.Ring.gradientMiddle2,
                    StoriesColor.Ring.gradientEnd
                ],
                startPoint: .bottomLeading,
                endPoint: .topTrailing
            ))
        }
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
