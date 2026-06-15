//
//  StoryServiceMock.swift
//  StoriesApp
//
//  Created by Pauline Nomballais on 15/06/2026.
//

#if DEBUG
import Foundation

final class StoryServiceMock: StoryServiceProtocol {

    func fetchStories() throws -> [StoryGroup] {
        return [
            StoryGroup(
                user: User(name: "camillette", avatarURL: "https://randomuser.me/api/portraits/women/1.jpg"),
                items: [
                    StoryItem(imageURL: "https://picsum.photos/seed/camillette1/800/1400"),
                    StoryItem(imageURL: "https://picsum.photos/seed/camillette2/800/1400")
                ]
            ),
            StoryGroup(
                user: User(name: "lucas_off", avatarURL: "https://randomuser.me/api/portraits/men/2.jpg"),
                items: [
                    StoryItem(imageURL: "https://picsum.photos/seed/lucasoff1/800/1400"),
                    StoryItem(imageURL: "https://picsum.photos/seed/lucasoff2/800/1400")
                ]
            ),
            StoryGroup(
                user: User(name: "manonmns", avatarURL: "https://randomuser.me/api/portraits/women/3.jpg"),
                items: [
                    StoryItem(imageURL: "https://picsum.photos/seed/manonmns1/800/1400"),
                    StoryItem(imageURL: "https://picsum.photos/seed/manonmns2/800/1400")
                ]
            )
        ]
    }
}
#endif
