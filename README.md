# ReadySetGo

A lightweight iOS score-tracking app built with SwiftUI. Designed for board games, card games, or any activity where you need a quick and simple way to keep score for multiple players.

## How It Works

The app follows a three-step flow:

### 1. Choose Player Count

On launch you pick how many players are joining (1 to 8). Use the **+** / **-** buttons to adjust — the count animates between values with haptic feedback — then tap **Next**.

### 2. Enter Player Names

Each player gets a text field paired with a unique color indicator. Fill in every name — the **Start Game** button activates once all names are entered. The keyboard advances automatically from one field to the next.

### 3. Game Board

The screen fills with rounded, color-coded tiles — one per player — showing the player's name and current score. Scores animate with a numeric content transition on every change.

| Gesture | What it does |
|---|---|
| **Tap** a tile | Increment that player's score by 1 |
| **Long-press** a tile | Decrease score by 1 (confirmation required) |

At the bottom of the board two actions are available:

| Action | What it does |
|---|---|
| **Reset Scores** | Sets every player's score back to 0 (confirmation required) |
| **New Game** | Clears everything and returns to the player-count screen (confirmation required) |

The layout adapts automatically: with 1–2 players the tiles stack vertically in a single column; with 3+ players they arrange in a two-column grid.

## Features

- **Liquid Glass UI** — buttons and tiles use `.glassEffect` with gradient backgrounds for a modern iOS 26 look
- **Haptic feedback** — sensory feedback on score changes and player count adjustments
- **Animated transitions** — numeric content transitions on scores and player count, smooth phase animations between screens
- **Accessibility** — VoiceOver labels and hints on all interactive elements

## Tech Stack

- **Language:** Swift
- **UI Framework:** SwiftUI (iOS 26+)
- **Architecture:** MVVM — `@Observable` `GameViewModel` drives all state; views observe and react with fine-grained tracking
- **Observation:** `@Observable` macro (replaces `ObservableObject` / `@Published`)

## Project Structure

```
ReadySetGo/
├── ReadySetGoApp.swift          # App entry point & phase-based navigation
├── Models/
│   └── Player.swift             # Player model (name, score, color) — Identifiable & Equatable
├── ViewModels/
│   └── GameViewModel.swift      # Game state, phase transitions, score logic
└── Views/
    ├── PlayerCountView.swift    # Step 1 – select number of players
    ├── PlayerNamesView.swift    # Step 2 – enter player names
    └── GameBoardView.swift      # Step 3 – score tracking board (includes PlayerTileView & GameAlert)
```

## Getting Started

1. Clone the repository:
   ```bash
   git clone https://github.com/jeremycalles/ReadySetGo.git
   ```
2. Open `ReadySetGo.xcodeproj` in Xcode 26 or later.
3. Select a simulator or connected device and press **Run** (⌘R).

> **Note:** This project uses iOS 26 APIs (`.glassEffect`, `.sensoryFeedback`). Xcode 26+ and an iOS 26+ target are required.

## License

This project is licensed under the [MIT License](LICENSE). You are free to use, modify, and distribute this software as long as the original copyright notice — including the repository name — is retained.
