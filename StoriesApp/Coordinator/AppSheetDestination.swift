//
//  AppSheetDestination.swift
//  StoriesApp
//
//  Created by Pauline Nomballais on 15/06/2026.
//

import Foundation

enum AppSheetDestination: Identifiable {
    case story(startIndex: Int)

    var id: String { "story" }
}
