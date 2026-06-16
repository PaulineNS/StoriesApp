//
//  SkeletonPostView.swift
//  StoriesApp
//
//  Created by Pauline Nomballais on 15/06/2026.
//

import SwiftUI

struct SkeletonPostView: View {

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            avatarNameHeader
            image
            description

        }
        .padding(.vertical, .space3v)
        .foregroundColor(StoriesColor.Feed.skeleton)
    }

    private var avatarNameHeader: some View {
        HStack(spacing: 10) {
            Circle()
                .frame(width: 36, height: 36)

            RoundedRectangle(cornerRadius: CornerRadius.xs.value)
                .frame(width: 120, height: 12)

            Spacer()
        }
        .padding(.horizontal, .space3v)
    }

    private var image: some View {
        Rectangle()
            .frame(maxWidth: .infinity)
            .frame(height: 500)
    }

    private var description: some View {
        VStack(alignment: .leading, spacing: 12) {
            RoundedRectangle(cornerRadius: CornerRadius.xs.value)
                .frame(maxWidth: .infinity)
                .frame(height: 12)

            RoundedRectangle(cornerRadius: CornerRadius.xs.value)
                .frame(width: 200, height: 12)
        }
        .padding(.horizontal, .space3v)
    }
}

#Preview {
    SkeletonPostView()
}
