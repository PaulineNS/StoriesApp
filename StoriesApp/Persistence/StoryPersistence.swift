//
//  StoryPersistence.swift
//  StoriesApp
//
//  Created by Pauline Nomballais on 15/06/2026.
//

import Foundation

final class StoryPersistence {

    let state: PersistenceState
    let service: PersistenceService

    init(service: PersistenceService = PersistenceServiceImpl()) {
        self.service = service
        self.state = service.loadState()
    }
}
