//
//  PersistenceServiceImplTests.swift
//  StoriesAppTests
//
//  Created by Pauline Nomballais on 16/06/2026.
//

import XCTest
@testable import StoriesApp

final class PersistenceServiceImplTests: XCTestCase {

    private var service: PersistenceServiceImpl!
    private let suiteName = "com.storiesapp.tests"

    override func setUp() {
        super.setUp()
        UserDefaults(suiteName: suiteName)?.removePersistentDomain(forName: suiteName)
        service = PersistenceServiceImpl(suiteName: suiteName)
    }

    override func tearDown() {
        UserDefaults(suiteName: suiteName)?.removePersistentDomain(forName: suiteName)
        service = nil
        super.tearDown()
    }

    func testLoadState_initialState_shouldBeEmpty() {
        let state = service.loadState()
        XCTAssertTrue(state.seenItemIds.isEmpty)
        XCTAssertTrue(state.likedItemIds.isEmpty)
    }

    func testSave_seenItem_shouldPersist() {
        let state = service.loadState()
        state.seenItemIds.insert("item-1")
        service.save(state)

        let reloaded = service.loadState()
        XCTAssertTrue(reloaded.seenItemIds.contains("item-1"))
    }

    func testSave_likedItem_shouldPersist() {
        let state = service.loadState()
        state.likedItemIds.insert("item-1")
        service.save(state)

        let reloaded = service.loadState()
        XCTAssertTrue(reloaded.likedItemIds.contains("item-1"))
    }

    func testSave_removeLikedItem_shouldPersist() {
        let state = service.loadState()
        state.likedItemIds.insert("item-1")
        service.save(state)

        state.likedItemIds.remove("item-1")
        service.save(state)

        let reloaded = service.loadState()
        XCTAssertFalse(reloaded.likedItemIds.contains("item-1"))
    }

    func testSave_multipleSeenItems_shouldPersistAll() {
        let state = service.loadState()
        state.seenItemIds.insert("item-1")
        state.seenItemIds.insert("item-2")
        state.seenItemIds.insert("item-3")
        service.save(state)

        let reloaded = service.loadState()
        XCTAssertEqual(reloaded.seenItemIds, ["item-1", "item-2", "item-3"])
    }

    func testLoadState_afterSave_shouldReturnSameData() {
        let state = service.loadState()
        state.seenItemIds.insert("item-1")
        state.likedItemIds.insert("item-2")
        service.save(state)

        let reloaded = service.loadState()
        XCTAssertEqual(reloaded.seenItemIds, state.seenItemIds)
        XCTAssertEqual(reloaded.likedItemIds, state.likedItemIds)
    }

    func testSave_multipleSaves_lastShouldWin() {
        let state1 = service.loadState()
        state1.seenItemIds.insert("item-1")
        service.save(state1)

        let state2 = service.loadState()
        state2.seenItemIds.remove("item-1")
        state2.seenItemIds.insert("item-2")
        service.save(state2)

        let reloaded = service.loadState()
        XCTAssertFalse(reloaded.seenItemIds.contains("item-1"))
        XCTAssertTrue(reloaded.seenItemIds.contains("item-2"))
    }
}
