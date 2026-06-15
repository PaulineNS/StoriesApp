//
//  StoryGroup.swift
//  StoriesApp
//
//  Created by Pauline Nomballais on 15/06/2026.
//

import Foundation

struct StoryGroup: Codable {
    let user: User
    let items: [StoryItem]
}
