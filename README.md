# The Desk

**A two-phone crime story.** The paper prints the death. Then the death happens.

You play **Rowan Hale**, night archivist at *The Marrow Bay Ledger*. At 2:17 a.m. an unknown sender texts you an obituary that has not happened yet. At 6:02 it has. Then they put Vera Quinn’s phone in your hand.

The early edition does not predict death. It **collects** names. Marrow Bay’s 1894 charter keeps the harbor “bound” so long as an obituary sits on the desk before dawn.

Four editions. One last line.

This repository is a Flutter app (`mysterious`) that presents the entire campaign as a custom phone OS — **MarrowOS** — with two devices, a typed-URL browser, voicemail, corrupted files, a case board, and a town social feed. Tone and structure sit in the lineage of *An Elmwood Trail*: you investigate by using the phones, not by walking a 3D map.

---

## Contents

- [Play](#play)
- [Requirements](#requirements)
- [Run](#run)
- [Test](#test)
- [What you are investigating with](#what-you-are-investigating-with)
- [The four editions](#the-four-editions)
- [Architecture](#architecture)
- [Project layout](#project-layout)
- [Story and art](#story-and-art)
- [Tech stack](#tech-stack)
- [Walkthrough (spoilers)](#walkthrough-spoilers)

---

## Play

Follow the **red TASK bar**. Tap it to jump to the relevant app. **HINT** gives three pushes per task; after that, re-read Photos, Notes, and Pier Feed.

You will:

1. Answer chats. Wording changes what people confess — and how the last line of the campaign reads.
2. Switch phones. Vera’s device is locked. The PIN is a **time**, not a death.
3. Type URLs. This browser does not search. Addresses hide in chats, voicemail, and the case board.
4. Recover files in compositor order. Match three proofs per edition.
5. Read **Pier Feed** for the town’s official lie.

Nothing is an energy gate. If you are stuck, the red bar and hints are the intended path.

---

## Requirements

- [Flutter](https://docs.flutter.dev/get-started/install) **stable**, Dart SDK **3.5 or later** (`pubspec.yaml` requires `>=3.5.0 <4.0.0`)
- Chrome (or another Flutter web target) for the fastest loop
- Xcode / CocoaPods for iOS; Android SDK for Android (optional)

Confirm the toolchain:

```bash
flutter doctor
```

---

## Run

From the repository root:

```bash
flutter pub get
flutter run -d chrome
```

On a physical phone or simulator:

```bash
flutter devices
flutter run -d <device-id>
```

Release builds:

```bash
flutter build web
flutter build apk
flutter build ios
```

On screens wider than **520px**, the UI sits in a phone frame (`PhoneFrame` in `lib/widgets/chrome.dart`). On a real phone it is full-bleed. The web PWA name is **The Desk** (`web/manifest.json`); Android/iOS display names match.

Google Fonts are loaded at runtime (`google_fonts`). The first launch needs network access for font files unless you later vendor them.

---

## Test

```bash
flutter test
flutter analyze
```

| File | What it protects |
| --- | --- |
| `test/widget_test.dart` | Title screen masthead (`The Desk` / `MYSTERIOUS`) |
| `test/layout_test.dart` | Home grid, lock screen, and related layouts do not overflow on a phone-sized surface |
| `test/episode_flow_test.dart` | Full four-edition campaign via `GameController(instant: true)`, plus the three-hint cap |

`instant: true` skips typed delays so story flags can be driven in unit tests without pumping timers.

---

## What you are investigating with

MarrowOS is a home grid of apps, not a single chat window.

| App | Role |
| --- | --- |
| **Messages** | Interrogation. Threads appear and vanish by phone and story flag. |
| **Phone / Recents / Voicemail** | Dial numbers you find in copy. Listen before you call. |
| **Browser** | Type an address exactly. No search, no `www`. |
| **Files** | Corrupted fragments. Tap them in compositor order. |
| **Notes** | Passworded diaries (Vera, then later pages). |
| **Case** | Pair six proof cards into three locks per edition. |
| **Photos** | Still evidence and location art. |
| **Pier Feed** | Civic posts gated on flags — the town’s official weather. |
| **Editions** | Campaign progress and, at the end, the last line you set. |

Two devices:

- **Rowan Hale** — night desk, your phone.
- **Vera Quinn** — editor-in-chief, locked until the press has already taken her.

Switch from the shell chrome. Inbox contents are phone-specific (`GameController.inbox`).

---

## The four editions

Copy lives in `lib/data/story.dart` (`Story.editions`). Blurbs are safe to read; solutions are not.

1. **The Ink Tray** — The paper prints Vera. Then Vera happens.
2. **Job Ticket 1102** — Ruth Calder has until 6:02. She set a girl in Caslon and kept the plate.
3. **The Ninth Window** — Room 9 is a page. Sable wants it bound or burned.
4. **Special Edition** — The last line of your obituary is still blank. You have to set it.

Endings (edition 4) are three typed URLs. One of them requires melting the alloy in Files first. See [Walkthrough](#walkthrough-spoilers).

---

## Architecture

The app is a single `ChangeNotifier` game with named Flutter routes.

```
TitleScreen  ──►  PhoneShell (apps)
     │
     └── /how  HowToScreen
```

- **`NightDeskApp`** (`lib/main.dart`) — `ChangeNotifierProvider<GameController>`, dark `NightDeskTheme`, fade routes `/`, `/phone`, `/how`. Wide layouts wrap in `PhoneFrame`.
- **`GameController`** (`lib/state/game_controller.dart`) — phones, current app, clock, task, hint budget, episode, flags, chat threads, PIN, browser page, file taps, board matches, endings. Story advancement is flag-driven (`flags` is a `Set<String>`).
- **`Story`** (`lib/data/story.dart`) — editions, boards, file puzzles, diaries, feed, voicemails, chat beats, hint packs keyed by `phase`.
- **`Contacts` / `EpisodeCopy`** (`lib/data/models.dart`) — people, numbers, PIN, URLs, diary passwords, default board copy.
- **Screens** — one widget per app; they watch the controller and call its methods. They do not own campaign logic.

Typical loop: player action → controller mutates flags / drops lines / `_setTask` → `notifyListeners` → shell rebuilds.

Reply choices (`ReplyChoice`) set extra flags (`warnedVera`, `leakedToCamille`, `accusedHarlan`, …). Those change confession texture and last-line flavor; they do not skip editions.

---

## Project layout

```
lib/
  main.dart
  data/
    assets.dart          # image path constants
    models.dart          # contacts, cards, diaries, EpisodeCopy
    story.dart           # campaign content and hint packs
  state/
    game_controller.dart # all gameplay state
  theme/
    night_desk_theme.dart
  widgets/
    chrome.dart          # status bar, task banner, phone frame, lock chrome
  screens/
    title_screen.dart
    phone_shell.dart     # home grid, lock screen, app switch
    messages_screen.dart
    chat_screen.dart
    phone_app_screen.dart
    browser_screen.dart
    files_screen.dart
    notes_screen.dart
    board_screen.dart
    gallery_screen.dart
    feed_screen.dart
    editions_screen.dart
assets/images/           # key art, characters, locations, props, wallpapers
test/
android/  ios/  web/     # Flutter platform hosts
```

Package name: `mysterious`. Application id on Android: `com.nightdesk.mysterious`. Display title everywhere players see: **The Desk**. Series label: **Mysterious**.

---

## Story and art

Cinematic stills live in `assets/images/` and are declared as a folder asset in `pubspec.yaml`. Paths are centralized in `GameAssets`.

| Prefix | Use |
| --- | --- |
| `key_art_` / `bg_` | Title |
| `char_` | Portraits |
| `loc_` | Newsroom, press, archives, harbor, board, interrogation |
| `prop_` | Obituary, twins photo, evidence table |
| `wallpaper_` | Rowan vs Vera home screens |
| `avatar_moth.png` | UNKNOWN |

Palette (`InkColors`): void black, newsroom teal, brass, paper, blood. Type: **Cormorant Garamond**, **Special Elite**, **DM Sans**.

To add a beat: write copy and flags in `story.dart` / `models.dart`, then gate UI or drops in `GameController`. Prefer a new flag over a parallel state machine.

---

## Tech stack

| Piece | Choice |
| --- | --- |
| UI | Flutter 3, Material 3, custom dark theme |
| State | `provider` + `ChangeNotifier` |
| Fonts | `google_fonts` |
| Platforms | Web, iOS, Android |
| Lints | `flutter_lints` (`avoid_print: true`) |

Version: `0.1.0+1`. `publish_to: none` — this is a game, not a pub package.

There is no backend. All narrative is local.

---

## Walkthrough (spoilers)

<details>
<summary>Open only if you want solutions. In-game HINT is designed to get you here without this list.</summary>

### Edition 1 — The Ink Tray

Warn Vera. Unlock her phone (`0217`). Recover Sable. Call Ellis. Type `ledger.early`. Notes: `JUNE`. Match three proofs. Answer Camille as a dead woman.

### Edition 2 — Job Ticket 1102

Ruth Calder, retired compositor, is in the tray. Recover her file (**ticket first**). Call `207-555-1102`. Type `job1102.ledger`. Notes: `CASLON`.

### Edition 3 — The Ninth Window

Type `room9.ledger`, bind the page, read `charter.ledger`, Notes: `NINTH`. Learn who held the rope in 1999.

### Edition 4 — Special Edition

Match the last proofs. Melt `1894 / 1999 / 2:17 / 6:02`. Type **one** URL:

- `ledger.spike` — June becomes weather. You keep the job.
- `crowe.obit` — the mayor feeds the tray. Sable keeps a yesterday.
- `ledger.kill` — the desk dies. Go inland. (Requires the alloy melt in Files.)

### Constants (from `EpisodeCopy`)

| Kind | Value |
| --- | --- |
| Vera PIN | `0217` |
| Ellis | `207-555-1999` |
| Calder | `207-555-1102` |
| URLs | `ledger.early`, `job1102.ledger`, `room9.ledger`, `charter.ledger` |
| Endings | `ledger.spike`, `crowe.obit`, `ledger.kill` |
| Notes | `JUNE`, `CASLON`, `NINTH` |

The automated path through all four editions is `test/episode_flow_test.dart`.

</details>
