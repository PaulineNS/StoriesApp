//
//  AppRouterMock.swift
//  StoriesAppTests
//
//  Created by Pauline Nomballais on 16/06/2026.
//

import Foundation
@testable import StoriesApp

final class AppRouterMock: AppRouter {
    var presentedSheet: AppSheetDestination?
    var didDismiss = false
    var didPresent = false

    func present(sheet: AppSheetDestination) {
        presentedSheet = sheet
        didPresent = true
    }

    func dismissSheet() {
        didDismiss = true
        presentedSheet = nil
    }
}
