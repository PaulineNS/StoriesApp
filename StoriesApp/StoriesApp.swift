//
//  StoriesAppApp.swift
//  StoriesApp
//
//  Created by Pauline Nomballais on 15/06/2026.
//

import SwiftUI

@main
struct StoriesApp: App {

    @State private var router = AppRouterImpl()
    private let factory = AppFactory()

    init() {
        if CommandLine.arguments.contains("UI_TESTING") {
            if let bundleIdentifier = Bundle.main.bundleIdentifier {
                UserDefaults.standard.removePersistentDomain(forName: bundleIdentifier)
            }
        }
    }

    var body: some Scene {
        WindowGroup {
            AppRootView(factory: factory)
        }
    }
}
