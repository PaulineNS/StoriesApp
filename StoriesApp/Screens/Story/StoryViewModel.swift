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
    private var currentStoryIndex: Int

    private let router: AppRouter
    private let persistence: StoryPersistence
    private let appState: AppState
    private var timer: Timer?

    private static let storyItemDuration: CGFloat = 5.0
    private static let timerInterval: CGFloat = 0.05

    // MARK: - Init

    init(
        router: AppRouter,
        persistence: StoryPersistence,
        appState: AppState,
        startIndex: Int
    ) {
        self.router = router
        self.persistence = persistence
        self.appState = appState
        self.currentStoryIndex = startIndex
        self.currentStory = appState.stories[startIndex]
        self.currentItemIndex = firstUnseenItemIndex(in: appState.stories[startIndex])
    }

    // MARK: - Computed Properties

    var currentStoryItem: StoryItem {
        currentStory.items[currentItemIndex]
    }

    var isCurrentItemLiked: Bool {
        persistence.state.likedItemIds.contains(currentStoryItem.imageURL)
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
        currentItemIndex = firstUnseenItemIndex(in: currentStory)
        currentItemProgress = 0
        markCurrentItemAsSeen()
    }

    private func firstUnseenItemIndex(in story: Story) -> Int {
        story.items.firstIndex(where: {
            !persistence.state.seenItemIds.contains($0.imageURL)
        }) ?? 0
    }

    // MARK: - Persistence

    func markCurrentItemAsSeen() {
        persistence.state.seenItemIds.insert(currentStoryItem.imageURL)
        persistence.save()
    }

    func toggleLikeCurrentItem() {
        if persistence.state.likedItemIds.contains(currentStoryItem.imageURL) {
            persistence.state.likedItemIds.remove(currentStoryItem.imageURL)
        } else {
            persistence.state.likedItemIds.insert(currentStoryItem.imageURL)
        }
        persistence.save()
    }

    // MARK: - Actions

    func dismiss() {
        router.dismissSheet()
    }
}
