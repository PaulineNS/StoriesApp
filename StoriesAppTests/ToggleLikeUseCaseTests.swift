//
//  ToggleLikeUseCaseTests.swift
//  StoriesAppTests
//
//  Created by Pauline Nomballais on 22/06/2026.
//

import XCTest
@testable import StoriesApp

final class ToggleLikeUseCaseTests: XCTestCase {

    private var repositoryMock: PersistenceRepositoryMock!
    private var useCase: ToggleLikeUseCase!

    override func setUp() {
        super.setUp()
        repositoryMock = PersistenceRepositoryMock()
        useCase = ToggleLikeUseCase(repository: repositoryMock)
    }

    override func tearDown() {
        repositoryMock = nil
        useCase = nil
        super.tearDown()
    }

    func testExecute_whenNotLiked_shouldLikeAndReturnTrue() {
        let result = useCase.execute(imageURL: "image-1")
        XCTAssertTrue(result)
        XCTAssertTrue(repositoryMock.isItemLiked(imageURL: "image-1"))
    }

    func testExecute_whenAlreadyLiked_shouldUnlikeAndReturnFalse() {
        repositoryMock.likedItemIds.insert("image-1")
        let result = useCase.execute(imageURL: "image-1")
        XCTAssertFalse(result)
        XCTAssertFalse(repositoryMock.isItemLiked(imageURL: "image-1"))
    }

    func testExecute_shouldNotAffectOtherItems() {
        repositoryMock.likedItemIds.insert("image-2")
        _ = useCase.execute(imageURL: "image-1")
        XCTAssertTrue(repositoryMock.isItemLiked(imageURL: "image-2"))
    }
}
