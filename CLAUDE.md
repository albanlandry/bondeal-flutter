# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**BonDeal** — A peer-to-peer marketplace app for buying, selling, and exchanging items. French-language UI targeting Gabon (FCFA currency). Flutter port of the Expo/React Native app at `../bondeal/`.

- **Dart SDK:** ^3.10.8
- **Flutter SDK:** >=3.18.0
- **Platforms:** Android, iOS, Linux, macOS, Web, Windows

## Common Commands

```bash
flutter run                          # Run the app
flutter run -d chrome                # Run on Chrome (use when Android emulator is x86_64)
flutter test                         # Run all tests
flutter test test/widget_test.dart   # Single test file
flutter analyze                      # Static analysis
flutter pub get                      # Get dependencies
flutter build apk                   # Build Android
flutter build web                   # Build web
```

## Architecture

- **Routing:** `go_router` with `ShellRoute` for bottom tab navigation (Menu, Home, Favorites, Chat, Profile) and stack routes for all other screens
- **State:** Local `setState()` — no global state management library
- **Theme:** `lib/theme/app_theme.dart` — AppColors, AppSpacing constants matching the original RN theme
- **Models:** `lib/models/product.dart` — Product, ChatItem, Message, AppNotification
- **Mock Data:** `lib/models/mock_data.dart` — all mock data for screens
- **No Firebase:** Auth screens are UI-only with mock navigation flows

## Screen Structure

```
lib/
├── main.dart              # App entry, splash → router
├── router.dart            # GoRouter config, MainShell with BottomNavigationBar (5 tabs)
├── theme/app_theme.dart   # Colors, spacing, ThemeData
├── models/
│   ├── product.dart       # Product, ChatItem, Message, AppNotification
│   └── mock_data.dart     # All mock data for screens
├── widgets/
│   ├── product_card.dart  # ProductCard (list view), GridProductCard (grid view)
│   └── skeleton_loader.dart
└── screens/
    ├── splash_screen.dart
    ├── auth/              # login, signup, verify_number, set_password, setup_profile
    ├── home/              # home, favorites, item_details, post_item, notifications, dev_menu
    ├── chat/              # chat_list, chatroom
    ├── profile/           # profile, edit_profile
    ├── search/            # search, search_results
    └── settings/          # settings, notification_settings, privacy_settings, help_support, terms
```

## Key Dependencies

- `go_router` — Navigation/routing
- `cached_network_image` — Image loading with caching
- `image_picker` — Camera/gallery for post-item and profile setup
- `shared_preferences` — Local storage (search history)
- `flutter_animate` — Splash screen animations
- `google_fonts` — Typography
- `intl` — Internationalization utilities

## Navigation Flow

- Splash (animated BonDeal logo) → Home tab
- Menu tab: Development navigation menu linking to all screens (dev-only, remove in production)
- Auth: login → signup → verify-number → setup-profile → set-password
- Home → item-details, post-item, notifications, search → search-results
- Profile → edit-profile, settings → notification/privacy settings, help, terms
- Chat list → chatroom

## Known Issues

- **x86_64 Android emulator:** Flutter 3.38 dropped x86 native library support. Use `flutter run -d chrome`, a physical ARM device, or an ARM64 emulator image instead.
- **Gradle cache corruption:** If you see `Could not read workspace metadata` errors, stop the daemon (`cd android && ./gradlew --stop`) then delete `~/.gradle/caches/8.14/`.
