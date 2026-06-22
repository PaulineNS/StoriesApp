//
//  MarkStorySeenUseCase.swift
//  StoriesApp
//
//  Created by Pauline Nomballais on 22/06/2026.
//

import Foundation

protocol MarkStorySeenUseCaseProtocol {
    func execute(imageURL: String)
}

final class MarkStorySeenUseCase: MarkStorySeenUseCaseProtocol {

    private let repository: PersistenceRepositoryProtocol

    init(repository: PersistenceRepositoryProtocol) {
        self.repository = repository
    }

    func execute(imageURL: String) {
        repository.markAsSeen(imageURL: imageURL)
    }
}
