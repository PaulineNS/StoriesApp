# StoriesApp

Instagram Stories-like feature

## Features

- Horizontal story list with infinite pagination
- Seen / unseen visual indicator (gradient ring vs grey)
- Full-screen story viewer with animated progress bars
- Tap to navigate between items, swipe to change user, swipe down to dismiss, long press to pause
- Like / unlike with persistence across sessions

## Architecture

Clean Architecture (Domain / Data / Presentation) combined with MVVM-C and a shared `AppState`.

**Domain** holds the entities (`Story`, `User`, `StoryItem`), the repository protocols, and the UseCases (`FetchStoriesUseCase`, `LoadMoreStoriesUseCase`, `ToggleLikeUseCase`, `MarkStorySeenUseCase`) — pure business logic with no dependency on SwiftUI or any data source detail.

**Data** contains the concrete repositories (`StoryRepository`) that implement the Domain protocols, backed by `StoryService` for local JSON access.

**Presentation** holds the Views and ViewModels. ViewModels only depend on UseCases — they never know about repositories or services directly.

The main challenge was sharing state between `HomeViewModel` and `StoryViewModel`. When a story item is marked as seen in the viewer, the ring on the list needs to update instantly. I solved this with a shared `@Observable AppState` injected via `AppFactory`, avoiding any coupling between the two ViewModels.

**`AppRouter`** handles navigation, **`AppFactory`** assembles repositories, UseCases, views and ViewModels, **`AppState`** holds shared data.

## Concurrency

The data layer is fully `async`/`await`. `StoryService` reads and decodes the JSON off the main actor using `Task.detached`, while ViewModels are explicitly `@MainActor` since they drive the UI. `HomeView` uses `.task` instead of `.onAppear` to trigger async loading.

## Data

Local `stories.json` for structured data, remote images from `picsum.photos` and `randomuser.me`. No static assets bundled.

## Persistence

`UserDefaults` — appropriate for lightweight flag data (seen/liked item IDs). `PersistenceState` is `@Observable` for reactive UI updates without Combine.

## Design System

Color, spacing and corner radius tokens. Reusable `ViewModifier` extensions for alerts and gestures.

## Tests

Unit tests on UseCases (isolated with repository mocks), ViewModels, and `PersistenceServiceImpl`. UI tests for core user flows.

## Requirements

iOS 17+ · iPhone only · No external libraries
