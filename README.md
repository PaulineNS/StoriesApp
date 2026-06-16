# StoriesApp

Instagram Stories-like feature — iOS technical assessment.

## Features

- Horizontal story list with infinite pagination
- Seen / unseen visual indicator (gradient ring vs grey)
- Full-screen story viewer with animated progress bars
- Tap to navigate between items, swipe to change user, swipe down to dismiss, long press to pause
- Like / unlike with persistence across sessions

## Architecture

MVVM-C with a shared `AppState`.

The main challenge was sharing state between `HomeViewModel` and `StoryViewModel` — when a story item is marked as seen in the viewer, the ring on the list needs to update instantly. I solved this with a shared `@Observable AppState` injected via `AppFactory`, avoiding any coupling between the two ViewModels.

**`AppRouter`** handles navigation, **`AppFactory`** creates views and ViewModels, **`AppState`** holds shared data.

## Data

Local `stories.json` for structured data, remote images from `picsum.photos` and `randomuser.me`. No static assets bundled.

## Persistence

`UserDefaults` — appropriate for lightweight flag data (seen/liked item IDs). `PersistenceState` is `@Observable` for reactive UI updates without Combine.

## Design System

Color, spacing and corner radius tokens. Reusable `ViewModifier` extensions for alerts and gestures.

## Tests

Unit tests on `StoryViewModel`, `HomeViewModel` and `PersistenceServiceImpl`. UI tests for core user flows.

## Requirements

iOS 17+ · iPhone only · No external libraries
