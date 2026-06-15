//
//  AppState.swift
//  StoriesApp
//
//  Created by Pauline Nomballais on 15/06/2026.
//

import Foundation

@Observable
final class AppState {
    var stories: [Story] = []
    var currentPage: Int = 0
    var isLoadingMorePage: Bool = false
    var shouldLoadMorePage: Bool = false
}
