//
//  StoriesAppApp.swift
//  StoriesApp
//
//  Created by Pauline Nomballais on 15/06/2026.
//

import SwiftUI

@main
struct StoriesAppApp: App {

    @State private var router = AppRouterImpl()
    private let factory = AppFactory()

    var body: some Scene {
        WindowGroup {
            AppRootView(factory: factory)
        }
    }
}
