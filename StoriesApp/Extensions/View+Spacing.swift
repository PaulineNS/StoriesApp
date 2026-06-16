//
//  View+Spacing.swift
//  StoriesApp
//
//  Created by Pauline Nomballais on 16/06/2026.
//

import SwiftUI

struct SpacingModifier: ViewModifier {
    private let edge: Edge.Set
    private let spacing: CGFloat

    init(edge: Edge.Set, spacing: Spacing) {
        self.edge = edge
        self.spacing = spacing.value
    }

    func body(content: Content) -> some View {
        content
            .padding(edge, spacing)
    }
}

struct SpacingAllEdgesModifier: ViewModifier {
    private let spacing: CGFloat

    init(spacing: Spacing) {
        self.spacing = spacing.value
    }

    func body(content: Content) -> some View {
        content
            .padding(spacing)
    }
}

extension View {
    func padding(_ edge: Edge.Set, _ spacing: Spacing) -> some View {
        modifier(SpacingModifier(edge: edge, spacing: spacing))
    }

    func padding(_ spacing: Spacing) -> some View {
        modifier(SpacingAllEdgesModifier(spacing: spacing))
    }
}
