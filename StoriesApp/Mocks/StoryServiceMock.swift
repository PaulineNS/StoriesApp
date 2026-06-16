//
//  StoryServiceMock.swift
//  StoriesApp
//
//  Created by Pauline Nomballais on 15/06/2026.
//

#if DEBUG
import Foundation

@MainActor
final class StoryServiceMock: StoryServiceProtocol {

    static let mockStories: [Story] = (try? StoryServiceMock().fetchStories()) ?? []

    func fetchStories() throws -> [Story] {
        return [
            Story(
                id: "story-0",
                user: User(id: "user-0", name: "paulineNomballais", avatarURL: "https://randomuser.me/api/portraits/women/26.jpg", isCurrent: true),
                items: [
                    StoryItem(imageURL: "https://picsum.photos/seed/paulineNomballais2/800/1400"),
                    StoryItem(imageURL: "https://picsum.photos/seed/paulineNomballais7/800/1400")
                ]
            ),
            Story(
                id: "story-1",
                user: User(id: "user-1", name: "camillette", avatarURL: "https://randomuser.me/api/portraits/women/44.jpg", isCurrent: false),
                items: [
                    StoryItem(imageURL: "https://picsum.photos/seed/camillette1/800/1400"),
                    StoryItem(imageURL: "https://picsum.photos/seed/camillette4/800/1400"),
                    StoryItem(imageURL: "https://picsum.photos/seed/camillette5/800/1400")
                ]
            ),
            Story(
                id: "story-2",
                user: User(id: "user-2", name: "lucas_off", avatarURL: "https://randomuser.me/api/portraits/men/2.jpg", isCurrent: false),
                items: [
                    StoryItem(imageURL: "https://picsum.photos/seed/lucasoff4/800/1400"),
                    StoryItem(imageURL: "https://picsum.photos/seed/lucasoff5/800/1400")
                ]
            ),
            Story(
                id: "story-3",
                user: User(id: "user-3", name: "manonmns", avatarURL: "https://randomuser.me/api/portraits/women/3.jpg", isCurrent: false),
                items: [
                    StoryItem(imageURL: "https://picsum.photos/seed/manonmns0/800/1400"),
                    StoryItem(imageURL: "https://picsum.photos/seed/manonmns2/800/1400")
                ]
            ),
            Story(
                id: "story-4",
                user: User(id: "user-4", name: "theofts", avatarURL: "https://randomuser.me/api/portraits/men/4.jpg", isCurrent: false),
                items: [
                    StoryItem(imageURL: "https://picsum.photos/seed/theofts1/800/1400"),
                    StoryItem(imageURL: "https://picsum.photos/seed/theofts5/800/1400"),
                    StoryItem(imageURL: "https://picsum.photos/seed/theofts4/800/1400")
                ]
            ),
            Story(
                id: "story-5",
                user: User(id: "user-5", name: "leapls", avatarURL: "https://randomuser.me/api/portraits/women/5.jpg", isCurrent: false),
                items: [
                    StoryItem(imageURL: "https://picsum.photos/seed/leapls0/800/1400"),
                    StoryItem(imageURL: "https://picsum.photos/seed/leapls2/800/1400"),
                    StoryItem(imageURL: "https://picsum.photos/seed/leapls3/800/1400")
                ]
            ),
            Story(
                id: "story-6",
                user: User(id: "user-6", name: "hugoooo", avatarURL: "https://randomuser.me/api/portraits/men/6.jpg", isCurrent: false),
                items: [
                    StoryItem(imageURL: "https://picsum.photos/seed/hugoooo1/800/1400"),
                    StoryItem(imageURL: "https://picsum.photos/seed/hugoooo0/800/1400"),
                    StoryItem(imageURL: "https://picsum.photos/seed/hugoooo3/800/1400")
                ]
            ),
            Story(
                id: "story-7",
                user: User(id: "user-7", name: "chloeline", avatarURL: "https://randomuser.me/api/portraits/women/7.jpg", isCurrent: false),
                items: [
                    StoryItem(imageURL: "https://picsum.photos/seed/chloeline1/800/1400"),
                    StoryItem(imageURL: "https://picsum.photos/seed/chloeline2/800/1400"),
                    StoryItem(imageURL: "https://picsum.photos/seed/chloeline3/800/1400")
                ]
            ),
            Story(
                id: "story-8",
                user: User(id: "user-8", name: "nathaniel_", avatarURL: "https://randomuser.me/api/portraits/men/8.jpg", isCurrent: false),
                items: [
                    StoryItem(imageURL: "https://picsum.photos/seed/nathaniel1/800/1400"),
                    StoryItem(imageURL: "https://picsum.photos/seed/nathaniel2/800/1400"),
                    StoryItem(imageURL: "https://picsum.photos/seed/nathaniel4/800/1400")
                ]
            ),
            Story(
                id: "story-9",
                user: User(id: "user-9", name: "emmaalice", avatarURL: "https://randomuser.me/api/portraits/women/9.jpg", isCurrent: false),
                items: [
                    StoryItem(imageURL: "https://picsum.photos/seed/emmaalice0/800/1400"),
                    StoryItem(imageURL: "https://picsum.photos/seed/emmaalice4/800/1400"),
                    StoryItem(imageURL: "https://picsum.photos/seed/emmaalice5/800/1400")
                ]
            ),
            Story(
                id: "story-10",
                user: User(id: "user-10", name: "romainrmn", avatarURL: "https://randomuser.me/api/portraits/men/10.jpg", isCurrent: false),
                items: [
                    StoryItem(imageURL: "https://picsum.photos/seed/romainrmn1/800/1400"),
                    StoryItem(imageURL: "https://picsum.photos/seed/romainrmn0/800/1400"),
                    StoryItem(imageURL: "https://picsum.photos/seed/romainrmn3/800/1400")
                ]
            ),
            Story(
                id: "story-11",
                user: User(id: "user-11", name: "jadejdd", avatarURL: "https://randomuser.me/api/portraits/women/11.jpg", isCurrent: false),
                items: [
                    StoryItem(imageURL: "https://picsum.photos/seed/jadejdd1/800/1400"),
                    StoryItem(imageURL: "https://picsum.photos/seed/jadejdd2/800/1400"),
                    StoryItem(imageURL: "https://picsum.photos/seed/jadejdd3/800/1400")
                ]
            )
        ]
    }
}
#endif
