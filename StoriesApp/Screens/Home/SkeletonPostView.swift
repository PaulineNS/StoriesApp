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
        .padding(.vertical, 12)
        .foregroundColor(Color(.systemGray6))
    }

    private var avatarNameHeader: some View {
        HStack(spacing: 10) {
            Circle()
                .frame(width: 36, height: 36)

            RoundedRectangle(cornerRadius: 4)
                .frame(width: 120, height: 12)

            Spacer()
        }
        .padding(.horizontal, 12)
    }

    private var image: some View {
        RoundedRectangle(cornerRadius: 0)
            .frame(maxWidth: .infinity)
            .frame(height: 300)
    }

    private var description: some View {
        VStack(alignment: .leading, spacing: 12) {
            RoundedRectangle(cornerRadius: 4)
                .frame(maxWidth: .infinity)
                .frame(height: 12)

            RoundedRectangle(cornerRadius: 4)
                .frame(width: 200, height: 12)
        }
        .padding(.horizontal, 12)
    }
}
