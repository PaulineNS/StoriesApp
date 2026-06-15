//
//  PersistenceService.swift
//  StoriesApp
//
//  Created by Pauline Nomballais on 15/06/2026.
//

import Foundation

protocol PersistenceService {
    func loadState() -> PersistenceState
    func save(_ state: PersistenceState)
}
