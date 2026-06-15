//
//  StoryServiceMock.swift
//  StoriesApp
//
//  Created by Pauline Nomballais on 15/06/2026.
//

#if DEBUG
import Foundation

final class StoryServiceMock: StoryServiceProtocol {

    static let mockStories: [StoryGroup] = (try? StoryServiceMock().fetchStories()) ?? []

    func fetchStories() throws -> [StoryGroup] {
        return [
            StoryGroup(
                user: User(id: "user-0", name: "paulineNomballais", avatarURL: "https://randomuser.me/api/portraits/women/26.jpg", isCurrent: true),
                items: [
                    StoryItem(imageURL: "https://picsum.photos/seed/camillette1/800/1400"),
                    StoryItem(imageURL: "https://picsum.photos/seed/camillette2/800/1400")
                ]
            ),
            StoryGroup(
                user: User(id: "user-1", name: "camillette", avatarURL: "https://randomuser.me/api/portraits/women/1.jpg", isCurrent: false),
                items: [
                    StoryItem(imageURL: "https://picsum.photos/seed/camillette1/800/1400"),
                    StoryItem(imageURL: "https://picsum.photos/seed/camillette2/800/1400")
                ]
            ),
            StoryGroup(
                user: User(id: "user-2", name: "camillette", avatarURL: "https://randomuser.me/api/portraits/women/2.jpg", isCurrent: false),
                items: [
                    StoryItem(imageURL: "https://picsum.photos/seed/lucasoff1/800/1400"),
                    StoryItem(imageURL: "https://picsum.photos/seed/lucasoff2/800/1400")
                ]
            ),
            StoryGroup(
                user: User(id: "user-3", name: "camillette", avatarURL: "hhttps://randomuser.me/api/portraits/women/3.jpg", isCurrent: false),
                items: [
                    StoryItem(imageURL: "https://picsum.photos/seed/manonmns1/800/1400"),
                    StoryItem(imageURL: "https://picsum.photos/seed/manonmns2/800/1400")
                ]
            )
        ]
    }
}
#endif
