//
//  Spacing.swift
//  StoriesApp
//
//  Created by Pauline Nomballais on 16/06/2026.
//

import Foundation

public enum Spacing: CGFloat, CaseIterable {

    /// A Spacing of 0px
    case space0 = 0
    /// A Spacing of 4px
    case space1v = 4
    /// A Spacing of 8px
    case space1w = 8
    /// A Spacing of 12px
    case space3v = 12
    /// A Spacing of 16px
    case space2w = 16
    /// A Spacing of 24px
    case space3w = 24
    /// A Spacing of 32px
    case space4w = 32
    /// A Spacing of 40px
    case space5w = 40
    /// A Spacing of 48px
    case space6w = 48
    /// A Spacing of 56px
    case space7w = 56
    /// A Spacing of 64px
    case space8w = 64
    /// A Spacing of 80px
    case space10w = 80
    /// A Spacing of 96px
    case space12w = 96
    /// A Spacing of 120px
    case space15w = 120

    public var value: CGFloat {
        rawValue
    }
}
