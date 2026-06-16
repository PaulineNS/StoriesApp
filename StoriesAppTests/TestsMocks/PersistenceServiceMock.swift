//
//  PersistenceServiceMock.swift
//  StoriesAppTests
//
//  Created by Pauline Nomballais on 16/06/2026.
//

import Foundation
@testable import StoriesApp

final class PersistenceServiceMock: PersistenceService {
    var seenItems: Set<String> = []
    var likedItems: Set<String> = []

    func loadState() -> PersistenceState {
        let state = PersistenceState()
        state.seenItemIds = seenItems
        state.likedItemIds = likedItems
        return state
    }

    func save(_ state: PersistenceState) {
        seenItems = state.seenItemIds
        likedItems = state.likedItemIds
    }
}
