//
//  StoryError.swift
//  StoriesApp
//
//  Created by Pauline Nomballais on 16/06/2026.
//

import Foundation

enum StoryError: Error, Identifiable {
    case fileNotFound
    case unknown

    var id: String {
        switch self {
        case .fileNotFound: 
            return "fileNotFound"
        case .unknown: 
            return "unknown"
        }
    }

    var localizedDescription: String {
        switch self {
        case .fileNotFound:
            return "Unable to load stories. Please try again."
        case .unknown:
            return "An unexpected error occurred. Please try again."
        }
    }
}
