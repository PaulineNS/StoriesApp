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
    private var timer: Timer?
    private var stories: [Story]
    private var currentStoryIndex: Int

    private let storyItemDuration: CGFloat = 5.0
    private let timerInterval: CGFloat = 0.05

    init(
        router: AppRouter,
        stories: [Story],
        startIndex: Int
    ) {
        self.router = router
        self.stories = stories
        self.currentStoryIndex = startIndex
        self.currentStory = stories[startIndex]
    }

    var currentStoryItem: StoryItem {
        currentStory.items[currentItemIndex]
    }

    func startTimer() {
        stopTimer()
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
        }
    }

    func goToNextItem() {
        if currentItemIndex < currentStory.items.count - 1 {
            currentItemIndex += 1
            currentItemProgress = 0
        } else {
            goToNextStory()
        }
    }

    func goToPreviousItem() {
        if currentItemIndex > 0 {
            currentItemIndex -= 1
        }
        currentItemProgress = 0
    }

    private func goToNextStory() {
        if currentStoryIndex < stories.count - 1 {
            currentStoryIndex += 1
            currentStory = stories[currentStoryIndex]
            currentItemIndex = 0
            currentItemProgress = 0
        } else {
            dismiss()
        }
    }

    func dismiss() {
        router.dismissSheet()
    }
}
