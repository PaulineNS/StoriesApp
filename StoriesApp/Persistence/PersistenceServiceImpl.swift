//
//  PersistenceServiceImpl.swift
//  StoriesApp
//
//  Created by Pauline Nomballais on 15/06/2026.
//

import Foundation

final class PersistenceServiceImpl: PersistenceService {

    private let defaults = UserDefaults.standard
    private let seenKey = "seen_story_items"
    private let likedKey = "liked_story_items"

    func loadState() -> PersistenceState {
        let state = PersistenceState()
        state.seenItemIds = Set(defaults.stringArray(forKey: seenKey) ?? [])
        state.likedItemIds = Set(defaults.stringArray(forKey: likedKey) ?? [])
        return state
    }

    func save(_ state: PersistenceState) {
        defaults.set(Array(state.seenItemIds), forKey: seenKey)
        defaults.set(Array(state.likedItemIds), forKey: likedKey)
    }
}
