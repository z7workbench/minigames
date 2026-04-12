<p align="center"><img src="arts/minigames-main.webp"></p>

<p align="center">
    <a href="https://github.com/z7workbench/minigames/actions/workflows/android.yml"><img alt="Android build" src="https://github.com/z7workbench/minigames/actions/workflows/android.yml/badge.svg"></a>
    <a href="https://github.com/z7workbench/minigames/actions/workflows/linux.yml"><img alt="Linux build" src="https://github.com/z7workbench/minigames/actions/workflows/linux.yml/badge.svg"></a>
    <a href="https://github.com/z7workbench/minigames/actions/workflows/web.yml"><img alt="Web build" src="https://github.com/z7workbench/minigames/actions/workflows/web.yml/badge.svg"></a>
    <a href="https://github.com/z7workbench/minigames/actions/workflows/windows.yml"><img alt="Windows build" src="https://github.com/z7workbench/minigames/actions/workflows/windows.yml/badge.svg"></a>
    <a href="https://github.com/z7workbench/minigames/actions/workflows/macios.yml"><img alt="macOS & iOS build" src="https://github.com/z7workbench/minigames/actions/workflows/macios.yml/badge.svg"></a>
</p>

<p align="center">
  <strong>Mini Games Collection</strong> - A Flutter-based multi-game app inspired by Nintendo Switch's "Clubhouse Games: 51 Worldwide Classics"
</p>

<p align="center">
  <a href="#games">Games</a> •
  <a href="#installation">Installation</a> •
  <a href="#tech-stack">Tech Stack</a> •
  <a href="#contributing">Contributing</a>
</p>

---

## Games

| Game | Status | AI Modes | Save System |
|------|--------|----------|-------------|
| **Hit & Blow** | ✅ Complete | - | Leaderboard |
| **Yacht Dice** | ✅ Complete | Easy/Medium/Hard | 5 slots |
| **Guess Arrangement** | ✅ Complete | Easy/Medium/Hard | Records |
| **2048** | ✅ Complete | - | 5 slots + auto-save |
| **Mancala** | ✅ Complete | Easy/Medium/Hard | 5 slots |
| **Hearts** | ✅ Complete | Easy/Medium/Hard | 5 slots |
| **Dice Battle** | 🚧 WIP | Easy/Medium/Hard | Records |

---

### Hit & Blow

Hit & Blow is inspired by Nintendo Switch's Clubhouse Games: 51 Worldwide Classics' Hit & Blow.

**Description:**
A number guessing game where you deduce hidden `n` digits and their positions (default `n=4`). Select numbers from 1 to n and place them, then press "Check" for feedback:
- **Hit** (colored ✓): Correct number AND position
- **Blow** (grey ✓): Correct number, wrong position

Keep guessing until all positions are correct!

**Features:**
- Two difficulty levels: Easy (4 digits, 1-6), Hard (6 digits, 1-8)
- 10 attempts maximum
- Guess history tracking
- Timer and playtime statistics

---

### Yacht Dice

Simple Dice Game inspired by Nintendo Switch's Clubhouse Games: 51 Worldwide Classics' Yacht Dices.

**Description:**
Roll dice to create scoring combinations! After each roll, tap dice to "hold" good ones and reroll the rest. Double-tap a score category to confirm. Each category can only be used once per game. Highest score wins!

**Game Modes:**
- **2 Players**: Local multiplayer
- **vs AI**: Easy (random), Medium (rule-based), Hard (optimal strategy)

**Features:**
- Animated dice rolling
- Score preview with valid categories highlighted
- Hold and reroll mechanics (up to 3 rolls per turn)
- Save/resume game functionality
- All 13 Yahtzee-style categories

---

### Guess Arrangement

A card deduction game inspired by board game classics.

**Description:**
Two players draw 8 cards each and arrange them face-down from low to high (A=1, K=13). Take turns guessing opponent's cards by position and rank. Correct guesses reveal the card and earn combo points!

**Gameplay:**
- Guess: "Position 3 is a 7" (rank only, no suit)
- Correct: Card revealed, continue guessing, build combo
- Wrong: Turn passes, combo resets
- Win: First to reveal all opponent's cards

**Game Modes:**
- **2 Players**: Local multiplayer with hidden cards
- **vs AI**: Easy (random), Medium (position rules), Hard (probability analysis)

**Features:**
- Animated card flip effects
- Combo tracking system
- Position-based deduction (cards sorted ascending)
- AI turn summary dialog
- Game records persistence

---

### 2048

Classic tile-sliding puzzle game.

**Description:**
Slide tiles in four directions to merge matching numbers. When two tiles with the same value collide, they merge into one with double the value. Try to reach the 2048 tile!

**Gameplay:**
- Swipe up/down/left/right to move all tiles
- Matching tiles merge on collision
- New tile spawns after each move (90% = 2, 10% = 4)
- Game ends when no moves possible

**Scoring:**
- Base: Merged tile value (e.g., 4+4 → 8 points)
- Multi-merge bonus: ×1.5
- Consecutive merge bonus: ×2.0

**Features:**
- Animated tile sliding and spawning
- Auto-save every 3 minutes
- 5 save slots (1 auto + 4 manual)
- Best score tracking
- Game timer
- Light/Dark theme support

---

### Mancala

Ancient seed-sowing strategy game.

**Description:**
Capture more seeds than your opponent! Each player has 6 pits and a store. Pick seeds from your pit and sow them counter-clockwise.

**Gameplay:**
- Pick all seeds from one of your pits
- Sow one per pit counter-clockwise (skip opponent's store)
- Land in your store: Extra turn!
- Land in your empty pit with seeds opposite: Capture them all!
- Game ends when one side empty - remaining seeds go to owner's store
- Most seeds wins

**Game Modes:**
- **2 Players**: Local multiplayer
- **vs AI**: Easy (random), Medium (heuristics), Hard (minimax + alpha-beta)

**Features:**
- Animated seed sowing
- Turn indicator
- Extra turn logic
- Capture animations
- 5 save slots
- Game timer

---

### Hearts

Classic trick-taking card game - avoid hearts and the Queen of Spades!

**Description:**
Four-player Hearts with passing phase and shoot-the-moon mechanics. Avoid collecting points (hearts = 1 each, Q♠ = 13). First to 100 points loses!

**Gameplay:**
- **Pass Phase**: Select 3 cards to pass (Left → Right → Across → No Pass, rotating)
- **Trick-Taking**: Follow suit if possible, highest card wins trick
- **Scoring**: Hearts = 1 point each, Queen of Spades = 13 points
- **Shoot the Moon**: Collect all 26 points = opponents get 26 each instead!
- First player to 100 points triggers game end - lowest score wins

**Game Modes:**
- **Player vs 3 AI**: Human plays against AI opponents
- **AI Difficulties**: Easy (avoid points), Medium (strategic), Hard (card tracking + shoot moon)

**Features:**
- 4-pass direction rotation cycle
- Card tracking system (AI remembers played cards)
- Shoot-the-moon detection and scoring
- Pass timer option (15s, 30s, 60s, none)
- Moon announcement setting (hidden/shown)
- 5 save slots with full state persistence
- Scoreboard and trick history
- Rule validation and scoring logic

---

### Dice Battle 🚧 (Work In Progress)

Strategic dice combat with attack/defense phases and special effects!

**Description:**
A tactical dice battle game where players roll dice to attack and defend. Alternate between attack and defense phases, selecting dice for maximum damage or defense.

**Gameplay:**
- **Setup**: Each player chooses a dice set with unique attack/defense values
- **Coin Flip**: Random first player
- **Attack Phase**: Roll dice, select for attack, reroll up to 2 times
- **Defense Phase**: Defender rolls and selects dice for defense
- **Damage**: Attack total - Defense total = Damage dealt
- **Effects**: Special field effects activate from Round 2+
- Game ends when a player reaches 0 HP

**Game Modes:**
- **2 Players**: Local multiplayer
- **vs AI**: Easy (random), Medium (basic strategy), Hard (optimal selection + reroll)

**Note:** This game is currently under active development. Core mechanics are implemented but may have incomplete features or visual polish.

**Features (Implemented):**
- 6 unique dice types (Standard, Attack, Defense, etc.)
- 8 field effects (Odd Bonus, Even Bonus, Combo, Double Damage, etc.)
- Dice reroll system (max 2 per attack)
- Health bar visualization
- Battle log with turn history
- Animated damage display
- Dice selection and confirmation UI

---

## Screenshots

### Available Screenshots

| Game | Screenshot |
|------|------------|
| Hit & Blow | `arts/hnb.webp`, `arts/hnb_leaderboard.webp` |
| Yacht Dice | `arts/dices.webp` |

### Missing Screenshots (Coming Soon)
- Guess Arrangement
- 2048
- Mancala
- Hearts
- Dice Battle

---

## Installation

### Prerequisites

- **Flutter SDK**: 3.27+ ([Install Flutter](https://flutter.dev/docs/get-started/install))
- **Dart SDK**: 3.11+ (included with Flutter)
- **Platform-specific**:
  - Android: Android SDK, Java 17
  - iOS/macOS: Xcode 15+
  - Windows/Linux: Visual Studio Build Tools / Clang

### Quick Start

1. **Clone the repository**
   ```bash
   git clone https://github.com/z7workbench/minigames.git
   cd minigames
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code** (Required for Riverpod & Drift)
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Building for Platforms

```bash
# Android
flutter build apk
flutter build appbundle  # For Play Store

# iOS
flutter build ios
flutter build ipa        # For distribution

# Web
flutter build web        # Output: build/web/

# Windows
flutter build windows

# Linux
flutter build linux

# macOS
flutter build macos
```

### Development Workflow

```bash
# Watch mode for code generation (keeps running)
flutter pub run build_runner watch --delete-conflicting-outputs

# Run on specific device
flutter run -d android
flutter run -d ios
flutter run -d windows
flutter run -d macos
flutter run -d linux
flutter run -d chrome    # Web

# Run tests
flutter analyze
flutter test
```

---

## Tech Stack

| Category | Technology | Version | Purpose |
|----------|------------|---------|---------|
| **Framework** | Flutter | 3.27+ | Cross-platform UI |
| **Language** | Dart | 3.11+ | Application code |
| **Game Engine** | Flame | 1.19+ | Game rendering & logic |
| **Audio** | flame_audio | 2.10+ | Sound effects |
| **State Management** | Riverpod | 2.5+ | Reactive state |
| **Database** | Drift | 2.28+ | SQLite persistence |
| **Localization** | flutter_localizations | SDK | i18n support |
| **Storage** | shared_preferences | 2.2+ | Settings persistence |

---

## Platform Support

| Platform | Status | CI/CD |
|----------|--------|-------|
| Android | ✅ Full Support | GitHub Actions |
| iOS | ✅ Full Support | GitHub Actions |
| Web | ✅ Full Support | GitHub Actions |
| Windows | ✅ Full Support | GitHub Actions |
| Linux | ✅ Full Support | GitHub Actions |
| macOS | ✅ Full Support | GitHub Actions |

**All games run offline** - no network dependencies required.

---

## Project Structure

```
lib/
├── data/                      # Data layer (Drift database)
│   ├── database.dart          # Main database class
│   ├── tables/                # Table definitions
│   │   ├── game_records.dart
│   │   ├── game_settings.dart
│   │   ├── user_progress.dart
│   │   ├── yacht_dice_saves.dart
│   │   ├── twenty48_saves.dart
│   │   ├── hearts_saves.dart
│   │   └── mancala_saves.dart
│   └── daos/                  # Data access objects
│   └── providers/             # Database providers
│
├── games/                     # Game implementations
│   ├── hit_and_blow/          # Number guessing game
│   ├── yacht_dice/            # Yahtzee-style dice game
│   ├── guess_arrangement/     # Card deduction game
│   ├── twenty48/              # 2048 puzzle
│   ├── mancala/               # Seed-sowing game
│   ├── hearts/                # Trick-taking card game
│   └── dice_battle/           # Dice combat RPG
│
├── ui/                        # Shared UI layer
│   ├── screens/               # App screens (home, settings)
│   ├── widgets/               # Reusable widgets
│   │   ├── game_card.dart
│   │   ├── wooden_button.dart
│   │   └── wooden_app_bar.dart
│   └── theme/                 # Theme system
│       ├── app_theme.dart
│       ├── wooden_colors.dart
│       ├── starlight_colors.dart
│       ├── forest_colors.dart
│       ├── theme_colors.dart  # Theme-aware extensions
│       └── theme_provider.dart
│
├── l10n/                      # Internationalization
│   ├── app_en.arb             # English
│   ├── app_zh.arb             # Chinese
│   └── generated/             # Generated localizations
│
├── providers/                 # Global state providers
├── models/                    # Shared data models
├── utils/                     # Utilities
└── main.dart                  # App entry point
```

### Architecture

**Three-layer architecture:**
- **Data Layer** (`data/`): Drift database, tables, DAOs for persistence
- **Game Layer** (`games/`): Flame engine, game logic, AI systems
- **UI Layer** (`ui/`): Flutter widgets, screens, theme system

---

## Theme System

This app supports **3 color schemes × 2 brightness modes = 6 theme combinations**:

| Color Scheme | Light Mode | Dark Mode |
|--------------|------------|-----------|
| **Wooden** | Warm wood tones (khaki, brown) | Dark walnut (deep brown, ebony) |
| **Starlight** | Soft purple, sky blue | Deep purple, navy blue |
| **Forest** | Soft green, mint | Dark forest (deep green) |

### Theme-Aware Color Usage

When developing components, **always use theme-aware colors** from `context.theme*` extension:

```dart
import 'package:flutter/material.dart';
import '../../ui/theme/theme_colors.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // ✅ Correct: Auto-adapts to Wooden/Starlight/Forest + Dark/Light
      color: context.themeBackground,
      child: Text(
        'Hello',
        style: TextStyle(color: context.themeTextPrimary),
      ),
    );
  }
}
```

### Available Theme Colors

| Extension | Usage |
|-----------|-------|
| `context.themePrimary` | Primary color (AppBar, main buttons) |
| `context.themeBackground` | Background color (Scaffold) |
| `context.themeSurface` | Surface color (cards, containers) |
| `context.themeCard` | Card background |
| `context.themeAccent` | Accent color (icons, highlights) |
| `context.themeTextPrimary` | Primary text |
| `context.themeTextSecondary` | Secondary text |
| `context.themeBorder` | Border color |
| `context.themeOnPrimary` | Text/icons on primary color (AppBar icons) |
| `context.themeSuccess` | Success/positive color |
| `context.themeError` | Error/negative color |
| `context.themeWarning` | Warning color |

### ❌ Never Hardcode Colors

```dart
// ❌ WRONG: This breaks Starlight/Forest theme
Icon(Icons.settings, color: WoodenColors.accentAmber),

// ✅ CORRECT: Works for all themes
Icon(Icons.settings, color: context.themeOnPrimary),
```

### Pre-adapted Shared Components

These components are already theme-aware:
- `WoodenButton` - Button (primary, secondary, accent, ghost variants)
- `WoodenAppBar` - Application bar
- `GameCard` - Game selection card
- `ThemeToggle` - Theme switch control

---

## Contributing

Contributions are welcome! Please follow these guidelines.

### Development Setup

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Make your changes following existing patterns
4. Run tests and linting: `flutter analyze && flutter test`
5. Commit using [Conventional Commits](https://www.conventionalcommits.org/)
6. Push: `git push origin feature/amazing-feature`
7. Open a Pull Request

### Code Style

- **Files**: `snake_case` (e.g., `game_records_dao.dart`)
- **Classes**: `PascalCase` (e.g., `GameRecordsDao`)
- **Methods/Variables**: `camelCase` (e.g., `getHighScore`)
- **Private members**: `_prefix` (e.g., `_database`)
- Run `flutter format .` before committing

### Commit Message Format

```
<type>(<scope>): <description>

Types: feat, fix, docs, refactor, test, chore
Scopes: game, ui, data, i18n, theme, deps

Examples:
- feat(game): add Hearts AI hard difficulty
- fix(data): correct high score calculation
- docs(readme): add installation section
- refactor(ui): extract theme colors to extension
```

### Adding a New Game

1. Create game folder: `lib/games/<game_name>/`
2. Implement:
   - Provider (state management with Riverpod)
   - Screen (main game UI)
   - Models (game state, data structures)
   - Components (reusable widgets)
   - AI (if applicable: easy, medium, hard)
3. Add to `GameType` enum in `lib/models/game_type.dart`
4. Update `lib/ui/screens/home_screen.dart` navigation
5. Add localization strings to `lib/l10n/app_en.arb` and `app_zh.arb`
6. Create database table if save system needed
7. Update this README

---

## Used Libraries & Materials

- [Flutter](https://flutter.dev) - Cross-platform framework
- [Dart](https://dart.dev) - Programming language
- [Flame](https://flame-engine.org) - Game engine
- [Riverpod](https://riverpod.dev) - State management
- [Drift](https://drift.simonbinder.eu) - Database
- [flutter_localizations](https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization) - i18n

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

Copyright (c) 2021 ZeroGo Yoosee

---

## Acknowledgments

- Inspired by Nintendo Switch's "Clubhouse Games: 51 Worldwide Classics"
- Built with the amazing Flame game engine
- Thanks to the Flutter and Dart communities
- AI algorithms adapted from classic game theory implementations

---

<p align="center">
  Made with ❤️ using Flutter & Flame
</p>