//
//  User.swift
//  StoriesApp
//
//  Created by Pauline Nomballais on 15/06/2026.
//

import Foundation

struct User: Codable {
    let id: String
    let name: String
    let avatarURL: String
    let isCurrent: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case avatarURL = "avatar_url"
        case isCurrent = "is_current"
    }
}
