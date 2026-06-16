//
//  Color.swift
//  StoriesApp
//
//  Created by Pauline Nomballais on 16/06/2026.
//

import SwiftUI

enum StoriesColor {

    // MARK: - Ring
    enum Ring {
        static let gradientStart = Color.yellow
        static let gradientMiddle1 = Color.orange
        static let gradientMiddle2 = Color.pink
        static let gradientEnd = Color.purple
    }

    // MARK: - Home
    enum Home {
        static let headerIcon = Color.primary
        static let headerTitle = Color.primary
    }

    // MARK: - Story
    enum Story {
        static let like = Color.red
        static let progressFill = Color.white
        static let progressBackground = Color.white.opacity(0.4)
        static let background = Color.black
        static let text = Color.white
        static let textSecondary = Color.white.opacity(0.8)
        static let icon = Color.white
        static let messageBorder = Color.white.opacity(0.5)
        static let tapZone = Color.clear
    }

    // MARK: - Feed
    enum Feed {
        static let background = Color(.systemBackground)
        static let skeleton = Color(.systemGray6)
    }

    // MARK: - Avatar
    enum Avatar {
        static let plusButtonForeground = Color(.label)
        static let labelText = Color.primary
    }
}
