//
//  Story.swift
//  StoriesApp
//
//  Created by Pauline Nomballais on 15/06/2026.
//

import Foundation

struct Story: Codable, Sendable {
    let id: String
    let user: User
    let items: [StoryItem]
}
