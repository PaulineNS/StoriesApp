//
//  MarkStorySeenUseCaseTests.swift
//  StoriesAppTests
//
//  Created by Pauline Nomballais on 22/06/2026.
//

import XCTest
@testable import StoriesApp

final class MarkStorySeenUseCaseTests: XCTestCase {

    private var repositoryMock: PersistenceRepositoryMock!
    private var useCase: MarkStorySeenUseCase!

    override func setUp() {
        super.setUp()
        repositoryMock = PersistenceRepositoryMock()
        useCase = MarkStorySeenUseCase(repository: repositoryMock)
    }

    override func tearDown() {
        repositoryMock = nil
        useCase = nil
        super.tearDown()
    }

    func testExecute_shouldMarkItemAsSeen() {
        useCase.execute(imageURL: "image-1")
        XCTAssertTrue(repositoryMock.isItemSeen(imageURL: "image-1"))
    }

    func testExecute_calledTwice_shouldRemainSeen() {
        useCase.execute(imageURL: "image-1")
        useCase.execute(imageURL: "image-1")
        XCTAssertTrue(repositoryMock.isItemSeen(imageURL: "image-1"))
    }

    func testExecute_shouldNotAffectOtherItems() {
        useCase.execute(imageURL: "image-1")
        XCTAssertFalse(repositoryMock.isItemSeen(imageURL: "image-2"))
    }
}
