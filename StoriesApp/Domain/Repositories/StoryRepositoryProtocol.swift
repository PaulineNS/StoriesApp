//
//  StoryRepositoryProtocol.swift
//  StoriesApp
//
//  Created by Pauline Nomballais on 22/06/2026.
//

import Foundation

protocol StoryRepositoryProtocol {
    func fetchStories() async throws -> [Story]
}
