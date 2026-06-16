//
//  StoryPersistence.swift
//  StoriesApp
//
//  Created by Pauline Nomballais on 15/06/2026.
//

import Foundation

final class StoryPersistence {

    let state: PersistenceState
    private let service: PersistenceService

    init(service: PersistenceService = PersistenceServiceImpl()) {
        self.service = service
        self.state = service.loadState()
    }

    func save() {
        service.save(state)
    }
}
