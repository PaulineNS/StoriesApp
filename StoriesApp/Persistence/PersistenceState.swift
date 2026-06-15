//
//  PersistenceState.swift
//  StoriesApp
//
//  Created by Pauline Nomballais on 15/06/2026.
//

import Foundation

@Observable
final class PersistenceState {
    var seenItemIds: Set<String> = []
    var likedItemIds: Set<String> = []
}
