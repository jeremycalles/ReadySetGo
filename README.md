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

## Secrets and local config

Do not commit secrets or local signing config. The repo uses **automatic signing** with no team ID in source; set your **Team** in Xcode (**Signing & Capabilities**). Other sensitive paths (e.g. `ExportOptions.plist`, `.env`, `*.xcconfig`, credentials) are listed in [.gitignore](.gitignore). Never commit API keys, tokens, or provisioning profiles.

## Publishing to the App Store

### Prerequisites

- **Apple Developer Program** membership ($99/year) — [developer.apple.com/programs](https://developer.apple.com/programs/)
- Your Apple ID added in **Xcode → Settings → Accounts**. In the project, set your **Team** under **Signing & Capabilities** (bundle ID is `com.readysetgo.app`)

### 1. Create the app in App Store Connect

1. Go to [App Store Connect](https://appstoreconnect.apple.com) → **My Apps** → **+** → **New App**.
2. Choose **iOS**, name (e.g. **ReadySetGo**), primary language, bundle ID **com.readysetgo.app** (must match the project), and SKU (e.g. `readysetgo-ios`).
3. Create the app. You'll add metadata and builds in the next steps.

### 2. Archive and upload from Xcode

1. In Xcode, select the **Any iOS Device (arm64)** destination (not a simulator).
2. **Product → Archive**. Wait for the archive to finish.
3. In the **Organizer** window, select the new archive and click **Distribute App**.
4. Choose **App Store Connect** → **Upload** → follow the prompts (keep default options: automatic signing, upload symbols).
5. After the upload completes, wait a few minutes for the build to appear in App Store Connect under the app's **TestFlight** / **App Store** tab.

### 3. Complete the App Store listing

In App Store Connect, open your app and fill in:

- **App Information:** Category (e.g. **Games** or **Utilities**), subcategory if needed.
- **Pricing and Availability:** Free or paid; countries/regions.
- **App Privacy:** Privacy policy URL (required); if the app doesn't collect data, you can state that and still need a policy URL.
- **Version Information** (for the version that uses the build you uploaded):
  - **Screenshots:** At least one screenshot per required device size (e.g. 6.7", 6.5", 5.5" for iPhone). Use the simulator or a device: run the app, capture, and upload in Media Manager.
  - **Description,** **Keywords,** **Support URL,** **Marketing URL** (optional).
  - **Build:** Select the build you uploaded.
  - **What's New in This Version:** Short release notes.

### 4. Submit for review

1. In the version's **App Store** tab, ensure all required fields are complete (no yellow or red warnings).
2. Under **App Review Information**, add contact details and any notes for the reviewer.
3. Click **Add for Review** (or **Submit for Review**). Accept the export compliance and other declarations.
4. Submit. Review usually takes from a few hours to a couple of days.

**Tip:** If the build doesn't appear under the version, wait a bit longer or check **TestFlight** for processing/errors. Resolve any missing compliance or icon issues in Xcode and upload a new build if needed.

## License

This project is licensed under the [MIT License](LICENSE). You are free to use, modify, and distribute this software as long as the original copyright notice — including the repository name — is retained.
