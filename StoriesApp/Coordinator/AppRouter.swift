//
//  AppRouter.swift
//  StoriesApp
//
//  Created by Pauline Nomballais on 15/06/2026.
//

import Foundation

protocol AppRouter: AnyObject {
    var presentedSheet: AppSheetDestination? { get set }
    func present(sheet: AppSheetDestination)
    func dismissSheet()
}
