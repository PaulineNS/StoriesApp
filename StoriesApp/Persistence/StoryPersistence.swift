//
//  StoryPersistence.swift
//  StoriesApp
//
//  Created by Pauline Nomballais on 15/06/2026.
//

import Foundation

final class StoryPersistence: PersistenceRepositoryProtocol {

    let state: PersistenceState
    private let service: PersistenceService

    init(service: PersistenceService = PersistenceServiceImpl()) {
        self.service = service
        self.state = service.loadState()
    }

    func save() {
        service.save(state)
    }

    func isItemLiked(imageURL: String) -> Bool {
        state.likedItemIds.contains(imageURL)
    }

    func isItemSeen(imageURL: String) -> Bool {
        state.seenItemIds.contains(imageURL)
    }

    func toggleLike(imageURL: String) {
        if state.likedItemIds.contains(imageURL) {
            state.likedItemIds.remove(imageURL)
        } else {
            state.likedItemIds.insert(imageURL)
        }
        save()
    }

    func markAsSeen(imageURL: String) {
        state.seenItemIds.insert(imageURL)
        save()
    }
}
