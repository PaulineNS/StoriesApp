//
//  HomeViewModel.swift
//  StoriesApp
//
//  Created by Pauline Nomballais on 15/06/2026.
//

import Foundation

@Observable
final class HomeViewModel {

    private(set) var stories: [StoryGroup] = []

    private let service: StoryServiceProtocol

    init(service: StoryServiceProtocol = StoryService()) {
        self.service = service
    }

    @MainActor
    func loadStories() {
        do {
            stories = try service.fetchStories()
        } catch {
            print("Failed to load stories: \(error)")
        }
    }
}
