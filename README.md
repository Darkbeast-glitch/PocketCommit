# 📱 Pocket Commit

Pocket Commit is a beautifully designed, distraction-free daily habit and commitment tracker built with Flutter. It focuses on helping users stick to their goals through a satisfying, swipe-based interface and gamified global streaks.

![Pocket Commit Mockup](assets/images/pocket_logo.png) <!-- Update with an actual screenshot or banner later -->

## ✨ Features

- **🃏 Stacked UI & Card Swiping:** A Tinder-style card swiper to smoothly browse through your daily goals.
- **✅ Satisfying Interactions:** Tap "Mark as Done" to check off your goal and instantly move it to your 'Completed' tab.
- **🔥 Global Streaks:** A Duolingo-style unified streak system to hold you accountable to show up every single day.
- **🗓️ Consistency Calendar:** A visual calendar that lets you see your progress over time at a glance.
- **⚡ Offline-First Architecture:** Powered by Hive for instantaneous local updates, which then quietly sync to Firebase in the background so you can check off tasks even on airplane mode.
- **🔒 Anonymous & Authenticated Options:** Sign in anonymously to start tracking instantly, or link an account to secure your data across devices.

## 🛠️ Tech Stack

- **Framework:** [Flutter](https://flutter.dev/) (Channel Stable)
- **State Management:** [Riverpod](https://riverpod.dev/) (`flutter_riverpod` - standard manual implementation, no code-gen)
- **Local Database:** [Hive](https://docs.hivedb.dev/) & `hive_flutter`
- **Backend & Auth:** [Firebase](https://firebase.google.com/) (Firestore, Firebase Auth)
- **UI Components:** `flutter_card_swiper` for buttery-smooth gestural navigation.
- **Code Generation:** `freezed` & `json_serializable` for robust, immutable data models.

## 🚀 Getting Started

To run this project, make sure you have [Flutter](https://flutter.dev/docs/get-started/install) installed. This project specifically uses [FVM (Flutter Version Management)](https://fvm.app/) to ensure version consistency.

### Prerequisites

- FVM installed (optional but highly recommended)
- Firebase project configured (You'll need your own `google-services.json` and `GoogleService-Info.plist` if running your own backend instance)

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/Darkbeast-glitch/PocketCommit.git
   cd PocketCommit
   ```

2. Install dependencies:

   ```bash
   fvm flutter pub get
   ```

3. Run code generators (Freezed/JSON Serializable):

   ```bash
   fvm flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. Run the app:
   ```bash
   fvm flutter run
   ```

## 🏗️ Architecture

Pocket Commit employs a clean, scalable architecture:

- **`data/models`**: Immutable application models generated with Freezed.
- **`data/datasource`**: Separation of remote (`CommitRemoteDataSource` with Firebase) and local (`CommitLocalDataSource` with Hive) logic for offline-first support.
- **`data/repository`**: Combining data sources to feed the UI with a single source of truth.
- **`viewmodel`**: Riverpod `StateNotifier` classes controlling entirely decoupled business logic and streak calculation.
- **`view`**: Pure UI, Reacting to `StateNotifierProvider` changes instantly.

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://github.com/Darkbeast-glitch/PocketCommit/issues).

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.
