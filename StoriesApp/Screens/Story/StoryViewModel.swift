//
//  StoryViewModel.swift
//  StoriesApp
//
//  Created by Pauline Nomballais on 15/06/2026.
//

import Foundation

@Observable
final class StoryViewModel {

    private(set) var currentStoryGroup: StoryGroup

    private let router: AppRouter

    init(router: AppRouter, storyGroup: StoryGroup) {
        self.router = router
        self.currentStoryGroup = storyGroup
    }

    var currentStoryItem: StoryItem {
        //TODO - manage currentItem index
        currentStoryGroup.items[0]
    }

    func dismiss() {
        router.dismissSheet()
    }
}
