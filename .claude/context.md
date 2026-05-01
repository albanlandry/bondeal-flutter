# BonDeal Flutter — Session Context

## User Profile

- Building a marketplace app (BonDeal) for Gabon market
- Has an existing Expo/React Native version at `../bondeal/` that serves as the reference implementation
- Works with Flutter on Windows 11 with Android SDK 36, Flutter 3.38.9 stable
- Uses an x86_64 Android emulator (ASUS I003DD profile) — needs ARM64 emulator or physical device for Flutter debug builds
- Prefers direct execution over lengthy explanations

## Project

BonDeal is a peer-to-peer marketplace app (buy/sell/exchange) targeting Gabon, with French-language UI and FCFA currency. This Flutter project is a port of the Expo/React Native app at `C:\Users\Administrator\Projects\bondeal`.

All UI text is French. Styling matches the original RN theme (primary #007AFF, success #28A745, gray #6C757D). When adding features, reference the Expo source at `../bondeal/` for exact behavior.

## Architecture Decisions

- **Routing:** `go_router` with `ShellRoute` for 5-tab bottom nav (Menu, Home, Favorites, Chat, Profile) + stack routes for all other screens
- **State:** Local `setState()` only — no Provider/Riverpod/BLoC. Simplicity over scalability for now.
- **No Firebase:** Auth screens exist but use no Firebase SDK — they are UI-only with mock navigation flows
- **Mock data:** All screens use hardcoded mock data from `lib/models/mock_data.dart`

## Screens Implemented (22 total)

| Area | Files |
|------|-------|
| Splash | `splash_screen.dart` — animated BonDeal logo with flutter_animate |
| Auth (5) | login, signup (country code dropdown), verify_number (6-digit OTP boxes), setup_profile (avatar+nickname), set_password (strength checklist) |
| Home (5) | home (list/grid toggle, categories, skeleton loading, FAB, profile modal), favorites, item_details (carousel, fullscreen, suggested items, bottom bar), post_item (listing type, image grid, category/condition pickers, tags), notifications |
| Chat (2) | chat_list, chatroom (message bubbles, send input) |
| Profile (2) | profile (stats grid, settings list), edit_profile |
| Search (2) | search (suggestions, recent history), search_results (sort/filter) |
| Settings (4) | settings, notification_settings (toggles), privacy_settings, help_support (FAQ), terms (consent checkboxes) |
| Dev (1) | dev_menu_screen — development navigation to all screens |

## Build & Runtime Status

- `flutter analyze`: 0 errors, 0 warnings (only info-level `__` lint hints)
- `flutter build web`: succeeds
- `flutter build apk`: succeeds (APK produced)
- **Android emulator issue:** "ASUS I003DD" is x86_64 emulator (AMD Ryzen host). Flutter 3.38 dropped x86 Android native libs → `dlopen failed: ELF program header is invalid`. Not a code bug. Use ARM64 emulator, physical device, or `flutter run -d chrome`.
- **Gradle cache fix:** If `Could not read workspace metadata` error appears: `cd android && ./gradlew --stop && cd ..` then `rm -rf "$USERPROFILE/.gradle/caches/8.14"` and retry.

## Expo Source Reference

The original Expo app lives at `C:\Users\Administrator\Projects\bondeal`.

Key source locations:
- `app/(tabs)/` — Tab screens (index/menu, home, favorites, chat, profile)
- `app/` — Stack screens (login, signup, verify-number, set-password, setup-profile, item-details, post-item, chatroom, notifications, search, search-results, edit-profile, my-listings, settings, notification-settings, privacy-settings, help-support, terms-and-conditions)
- `utils/theme.js` — Theme colors and spacing
- `components/molecules/ProductCard.tsx` — Reusable product card
- `components/AnimatedSplashScreen.tsx` — Animated splash
- `contexts/PhoneAuthContext.tsx` — Firebase phone auth context
- `app.config.js` — App config with Firebase credentials and environment setup

## File Structure

```
lib/
├── main.dart              # Entry point, splash → router
├── router.dart            # GoRouter config, MainShell with BottomNavigationBar (5 tabs)
├── theme/app_theme.dart   # AppColors, AppSpacing, AppTheme.lightTheme
├── models/
│   ├── product.dart       # Product, ChatItem, Message, AppNotification
│   └── mock_data.dart     # All mock data
├── widgets/
│   ├── product_card.dart  # ProductCard (list), GridProductCard (grid)
│   └── skeleton_loader.dart
└── screens/               # 22 screen files across auth/, home/, chat/, profile/, search/, settings/
```

## Key Dependencies

go_router, cached_network_image, image_picker, shared_preferences, flutter_animate, google_fonts, intl

## Recent Session Notes

- 2026-05-01: Checked home-to-item-details navigation against RN reference. RN home uses `/item-details`; some RN screens pass `id` as params. Flutter had broken `/product/{id}` pushes while router only defined `/item-details`. Updated home and favorites cards to push `/item-details?id={id}`, made `/item-details` read the mock product id, added `/product/:id` redirect compatibility, and fixed details/favorites root navigation to `/home`.
- 2026-05-01: Git cleanup requested after optional build/platform files were pushed. Treat repo as Android/web-focused; ignore and remove optional Flutter platform scaffolds `ios/`, `linux/`, `macos/`, `windows/`, plus local `.claude/settings.local.json` and `.vscode/settings.json`. Keep `android/` and `web/`.
- Tooling note: `flutter analyze`, `dart analyze`, and `dart format` have timed out in recent sessions, so report validation status explicitly when they cannot complete.
