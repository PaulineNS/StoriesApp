//
//  PersistenceRepositoryMock.swift
//  StoriesAppTests
//
//  Created by Pauline Nomballais on 22/06/2026.
//

import Foundation
@testable import StoriesApp

final class PersistenceRepositoryMock: PersistenceRepositoryProtocol {

    var likedItemIds: Set<String> = []
    var seenItemIds: Set<String> = []

    func isItemLiked(imageURL: String) -> Bool {
        likedItemIds.contains(imageURL)
    }

    func isItemSeen(imageURL: String) -> Bool {
        seenItemIds.contains(imageURL)
    }

    func toggleLike(imageURL: String) {
        if likedItemIds.contains(imageURL) {
            likedItemIds.remove(imageURL)
        } else {
            likedItemIds.insert(imageURL)
        }
    }

    func markAsSeen(imageURL: String) {
        seenItemIds.insert(imageURL)
    }
}
