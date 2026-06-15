//
//  AppRootView.swift
//  StoriesApp
//
//  Created by Pauline Nomballais on 15/06/2026.
//

import SwiftUI

struct AppRootView: View {

    @State private var router = AppRouterImpl()
    let factory: AppFactory

    var body: some View {
        factory.makeHomeView(router: router)
            .fullScreenCover(item: $router.presentedSheet) { sheet in
                sheetView(for: sheet)
            }
    }

    @ViewBuilder
    private func sheetView(for sheet: AppSheetDestination) -> some View {
        switch sheet {
        case .story(let startIndex):
            factory.makeStoryView(router: router, startIndex: startIndex)
        }
    }
}

#Preview {
    AppRootView(factory: AppFactory())
}
