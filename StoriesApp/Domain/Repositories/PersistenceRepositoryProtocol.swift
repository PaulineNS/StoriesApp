//
//  PersistenceRepositoryProtocol.swift
//  StoriesApp
//
//  Created by Pauline Nomballais on 22/06/2026.
//

import Foundation

protocol PersistenceRepositoryProtocol {
    func isItemLiked(imageURL: String) -> Bool
    func isItemSeen(imageURL: String) -> Bool
    func toggleLike(imageURL: String)
    func markAsSeen(imageURL: String)
}
