//
//  StoryItem.swift
//  StoriesApp
//
//  Created by Pauline Nomballais on 15/06/2026.
//

import Foundation

struct StoryItem: Codable {
    let imageURL: String

    enum CodingKeys: String, CodingKey {
        case imageURL = "image_url"
    }
}
