//
//  AppSheetDestination.swift
//  StoriesApp
//
//  Created by Pauline Nomballais on 15/06/2026.
//

import Foundation

enum AppSheetDestination: Identifiable {
    case story(stories: [StoryGroup], startIndex: Int)

    var id: String {
        switch self {
        case .story: return "story"
        }
    }
}
