//
//  StoryViewModel.swift
//  StoriesApp
//
//  Created by Pauline Nomballais on 15/06/2026.
//

import Foundation

@Observable
@MainActor
final class StoryViewModel {

    // MARK: - Properties

    private(set) var currentStory: Story
    private(set) var currentItemIndex: Int = 0
    private(set) var currentItemProgress: CGFloat = 0
    private(set) var isCurrentItemLiked: Bool
    private var currentStoryIndex: Int

    private let router: AppRouter
    private let toggleLikeUseCase: ToggleLikeUseCaseProtocol
    private let markStorySeenUseCase: MarkStorySeenUseCaseProtocol
    private let persistenceRepository: PersistenceRepositoryProtocol
    private let appState: AppState
    private var timer: Timer?

    private static let storyItemDuration: CGFloat = 5.0
    private static let timerInterval: CGFloat = 0.05

    // MARK: - Init

    init(
        router: AppRouter,
        toggleLikeUseCase: ToggleLikeUseCaseProtocol,
        markStorySeenUseCase: MarkStorySeenUseCaseProtocol,
        persistenceRepository: PersistenceRepositoryProtocol,
        appState: AppState,
        startIndex: Int
    ) {
        self.router = router
        self.toggleLikeUseCase = toggleLikeUseCase
        self.markStorySeenUseCase = markStorySeenUseCase
        self.persistenceRepository = persistenceRepository
        self.appState = appState
        self.currentStoryIndex = startIndex
        self.currentStory = appState.stories[startIndex]
        let firstItemIndex = Self.firstUnseenItemIndex(in: appState.stories[startIndex], repository: persistenceRepository)
        self.currentItemIndex = firstItemIndex
        self.isCurrentItemLiked = persistenceRepository.isItemLiked(imageURL: appState.stories[startIndex].items[firstItemIndex].imageURL)
    }

    // MARK: - Computed Properties

    var currentStoryItem: StoryItem {
        currentStory.items[currentItemIndex]
    }

    // MARK: - Timer

    func startTimer() {
        stopTimer()
        markCurrentItemAsSeen()
        timer = Timer.scheduledTimer(withTimeInterval: Self.timerInterval, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.updateProgress()
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    func progressBarWidth(for index: Int, totalWidth: CGFloat) -> CGFloat {
        if index < currentItemIndex {
            return totalWidth
        } else if index == currentItemIndex {
            return totalWidth * currentItemProgress
        } else {
            return 0
        }
    }

    private func updateProgress() {
        let increment = Self.timerInterval / Self.storyItemDuration
        currentItemProgress += increment
        if currentItemProgress >= 1.0 {
            currentItemProgress = 0
            goToNextItem()
        }
    }

    // MARK: - Navigation

    func goToNextItem() {
        if currentItemIndex < currentStory.items.count - 1 {
            stopTimer()
            currentItemIndex += 1
            currentItemProgress = 0
            markCurrentItemAsSeen()
            refreshLikedState()
        } else {
            navigateToStory(direction: .next)
        }
    }

    func goToPreviousItem() {
        if currentItemIndex > 0 {
            stopTimer()
            currentItemIndex -= 1
            currentItemProgress = 0
            markCurrentItemAsSeen()
            refreshLikedState()
        } else {
            navigateToStory(direction: .previous)
        }
    }

    func navigateToStory(direction: StoryDirection) {
        switch direction {
        case .next:
            guard currentStoryIndex < appState.stories.count - 1 else {
                appState.shouldLoadMorePage = true
                return
            }
            currentStoryIndex += 1
        case .previous:
            guard currentStoryIndex > 0 else {
                currentItemIndex = 0
                currentItemProgress = 0
                startTimer()
                return
            }
            currentStoryIndex -= 1
        }
        stopTimer()
        currentStory = appState.stories[currentStoryIndex]
        currentItemIndex = Self.firstUnseenItemIndex(in: currentStory, repository: persistenceRepository)
        currentItemProgress = 0
        markCurrentItemAsSeen()
        refreshLikedState()
    }

    private static func firstUnseenItemIndex(in story: Story, repository: PersistenceRepositoryProtocol) -> Int {
        story.items.firstIndex(where: {
            !repository.isItemSeen(imageURL: $0.imageURL)
        }) ?? 0
    }

    // MARK: - Persistence

    func markCurrentItemAsSeen() {
        markStorySeenUseCase.execute(imageURL: currentStoryItem.imageURL)
    }

    func toggleLikeCurrentItem() {
        isCurrentItemLiked = toggleLikeUseCase.execute(imageURL: currentStoryItem.imageURL)
    }

    private func refreshLikedState() {
        isCurrentItemLiked = persistenceRepository.isItemLiked(imageURL: currentStoryItem.imageURL)
    }

    // MARK: - Actions

    func dismiss() {
        router.dismissSheet()
    }
}
