//
//  CornerRadius.swift
//  StoriesApp
//
//  Created by Pauline Nomballais on 16/06/2026.
//

import Foundation

enum CornerRadius {

    /// Value is 2px
    case xxs
    /// Value is 4px
    case xs
    /// Value is 12px
    case s
    /// Value is 24 px
    case m
    /// Value is size / 2 (fully rounded)
    case full(size: CGFloat)

    public var value: CGFloat {
        switch self {
        case .xxs:
            return 2
        case .xs:
            return 4
        case .s:
            return 12
        case .m:
            return 24
        case .full(let size):
            return size / 2
        }
    }
}
