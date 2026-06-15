//
//  StoryViewModel.swift
//  StoriesApp
//
//  Created by Pauline Nomballais on 15/06/2026.
//

import Foundation

@Observable
final class StoryViewModel {

    private(set) var currentStory: Story
    private(set) var currentItemIndex: Int = 0
    private(set) var currentItemProgress: CGFloat = 0

    private let router: AppRouter
    private let persistence: StoryPersistence
    private var timer: Timer?
    private var stories: [Story]
    private var currentStoryIndex: Int

    private let storyItemDuration: CGFloat = 5.0
    private let timerInterval: CGFloat = 0.05

    init(
        router: AppRouter,
        persistence: StoryPersistence,
        stories: [Story],
        startIndex: Int
    ) {
        self.router = router
        self.persistence = persistence
        self.stories = stories
        self.currentStoryIndex = startIndex
        self.currentStory = stories[startIndex]
        self.currentItemIndex = firstUnseenItemIndex(in: stories[startIndex])
    }

    var currentStoryItem: StoryItem {
        currentStory.items[currentItemIndex]
    }

    func startTimer() {
        stopTimer()
        markCurrentItemAsSeen()
        timer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true) { [weak self] _ in
            DispatchQueue.main.async {
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
        let increment = timerInterval / storyItemDuration
        currentItemProgress += increment
        if currentItemProgress >= 1.0 {
            currentItemProgress = 0
            goToNextItem()
        }
    }

    func goToNextItem() {
        if currentItemIndex < currentStory.items.count - 1 {
            stopTimer()
            currentItemIndex += 1
            currentItemProgress = 0
            markCurrentItemAsSeen()
        } else {
            goToNextStory()
        }
    }

    func goToPreviousItem() {
        stopTimer()
        if currentItemIndex > 0 {
            currentItemIndex -= 1
        }
        currentItemProgress = 0
        markCurrentItemAsSeen()
    }

    private func goToNextStory() {
        if currentStoryIndex < stories.count - 1 {
            stopTimer()
            currentStoryIndex += 1
            currentStory = stories[currentStoryIndex]
            currentItemIndex = 0
            currentItemProgress = 0
        } else {
            dismiss()
        }
    }

    private func firstUnseenItemIndex(in story: Story) -> Int {
        story.items.firstIndex(where: {
            !persistence.state.seenItemIds.contains($0.imageURL)
        }) ?? 0
    }

    func markCurrentItemAsSeen() {
        persistence.state.seenItemIds.insert(currentStoryItem.imageURL)
        persistence.service.save(persistence.state)
    }

    func toggleLikeCurrentItem() {
        if persistence.state.likedItemIds.contains(currentStoryItem.imageURL) {
            persistence.state.likedItemIds.remove(currentStoryItem.imageURL)
        } else {
            persistence.state.likedItemIds.insert(currentStoryItem.imageURL)
        }
        persistence.service.save(persistence.state)
    }

    func isCurrentItemLiked() -> Bool {
        persistence.state.likedItemIds.contains(currentStoryItem.imageURL)
    }

    func dismiss() {
        router.dismissSheet()
    }
}
