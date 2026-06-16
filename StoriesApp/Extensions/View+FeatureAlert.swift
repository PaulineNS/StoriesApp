//
//  View+FeatureAlert.swift
//  StoriesApp
//
//  Created by Pauline Nomballais on 16/06/2026.
//

import SwiftUI

extension View {
    func featureComingSoonAlert(isPresented: Binding<Bool>) -> some View {
        alert("Feature coming soon", isPresented: isPresented) {
            Button("OK", role: .cancel) {}
        }
    }
}
