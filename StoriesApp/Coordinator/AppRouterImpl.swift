//
//  AppRouterImpl.swift
//  StoriesApp
//
//  Created by Pauline Nomballais on 15/06/2026.
//

import Foundation

@Observable
@MainActor
final class AppRouterImpl: AppRouter {

    var presentedSheet: AppSheetDestination?

    func present(sheet: AppSheetDestination) {
        presentedSheet = sheet
    }

    func dismissSheet() {
        presentedSheet = nil
    }
}
