//
//  ToggleLikeUseCase.swift
//  StoriesApp
//
//  Created by Pauline Nomballais on 22/06/2026.
//

import Foundation

protocol ToggleLikeUseCaseProtocol {
    func execute(imageURL: String) -> Bool
}

final class ToggleLikeUseCase: ToggleLikeUseCaseProtocol {

    private let repository: PersistenceRepositoryProtocol

    init(repository: PersistenceRepositoryProtocol) {
        self.repository = repository
    }

    func execute(imageURL: String) -> Bool {
        repository.toggleLike(imageURL: imageURL)
        return repository.isItemLiked(imageURL: imageURL)
    }
}
