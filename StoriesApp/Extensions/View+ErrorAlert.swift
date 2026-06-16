//
//  View+ErrorAlert.swift
//  StoriesApp
//
//  Created by Pauline Nomballais on 16/06/2026.
//

import SwiftUI

struct ErrorAlertModifier: ViewModifier {
    @Binding var isPresented: Bool
    let error: StoryError?
    let onRetry: () -> Void

    func body(content: Content) -> some View {
        content
            .alert("Unable to load stories", isPresented: $isPresented) {
                Button("Retry") { onRetry() }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text(error?.localizedDescription ?? "")
            }
    }
}

extension View {
    func errorAlert(
        isPresented: Binding<Bool>,
        error: StoryError?,
        onRetry: @escaping () -> Void
    ) -> some View {
        modifier(ErrorAlertModifier(
            isPresented: isPresented,
            error: error,
            onRetry: onRetry
        ))
    }
}
