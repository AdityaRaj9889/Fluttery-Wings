# Fluttery Wings 🐦 — AAA Tap to Fly Game

> Play Store ready, premium 60fps infinite flyer built with **Flutter 3.24.5 + Flame + GetX**.

[![Flutter](https://img.shields.io/badge/Flutter-3.24.5-02569B?logo=flutter)](https://flutter.dev)
[![Flame](https://img.shields.io/badge/Flame-1.22.0-FF6B35?logo=flame)](https://flame-engine.org)
[![GetX](https://img.shields.io/badge/GetX-4.6.6-8A2BE2)](https://pub.dev/packages/get)
[![Play Store](https://img.shields.io/badge/Play%20Store-Ready-success?logo=googleplay)](https://play.google.com)

A fully polished, production-ready **Flappy Bird style** game with shop, themes, daily rewards, achievements, and monetization — following **Feature-first, Clean Architecture, SOLID, Repository Pattern**.

---

## 💎 What does AAA mean?

**AAA (Triple-A)** in gaming industry means:

- **A lot of money**, **A lot of time**, **A lot of resources** — like GTA, Call of Duty, Candy Crush — 100+ people team, $10M+ budget.

In **mobile indie context**, we use **AAA Feel** to mean **Play Store AAA Quality**, not budget:

| AAA Trait | How we did it in Fluttery Wings |
|---|---|
| **Premium Visuals** | Glassmorphism (blur 18, 14% opacity), gradients, shadows 18 blur, 60fps |
| **Juicy Feedback** | Scale 0.92 on tap, haptics light/medium/heavy, shimmer, elasticOut, particle-ready |
| **Polished UX** | Real-time shop sync, pause → TAP TO FLAP → resume flow, no jank, runZonedGuarded crash-proof |
| **Monetization Ready** | Rewarded ads with safe revive, interstitial, banner — crash-proof if manifest missing |
| **Architecture** | SOLid, Clean, Repository, DI, no warnings, null safety |
| **Content Depth** | 8 characters with modifiers (Phoenix 1.12 flap), 6 themes, 10 achievements, 7-day daily rewards |

So when we say **AAA Mobile Game**, we mean **feels like a top chart game**, even though built solo with Flutter.

---

## 📸 Screenshots

| Home (Theme & Character) | Gameplay (Ready) |
|---|---|
| ![Home](assets/screenshots/Screenshot_1784724618.png) | ![Gameplay](assets/screenshots/Screenshot_1784872008.png) |

> Screenshots show premium glassmorphism UI, animated bird preview, theme dots, and TAP TO FLAP ready state with pause/resume flow.

More screens: Shop, Daily Reward 7-day grid, Achievements with tiers, Leaderboard podium, Game Over with WATCH AD revive.

---

## ✨ Features

### 🎮 Core Gameplay
- **Tap to Fly** with tuned physics: gravity `920`, flap impulse `-360`, max fall `460`
- **Rotation system**: -0.45 up, 1.35 down, lerp factor 4.5 for juicy feel
- **60fps** optimized, hover on ready, no auto-fall bug

### 🌍 Infinite World
- **Random pipes**: width 78, gap 158, spacing 280, min height 60
- **Dynamic difficulty**: base speed 180 → max 340, +1.8 per score
- **Parallax background**: procedural clouds, hills, stars (night), cyber grid — no heavy textures

### 🪙 Coins & Collectibles
- **3D bobbing coins**: size 28, glow + shadow, scaleX 3D effect
- Safe spawn: never on pipes, 28px margin inside gap, 62% spawn chance
- Coin magnet ready, distance check collection (not buggy hitbox)

### 🛍️ Shop
- **8 Characters**: Classic (free), Blaze, Frost, Galaxy, Golden (2x magnet hint), Ninja (slim hitbox), Robo, Phoenix (legendary, 1.12 flap, 0.9 gravity)
- **6 Themes**: Sunny Day, Sunset, Midnight, Mystic Forest, Cyber City, Candy Land — each with sky, ground, pipe, cloud colors
- Prices 0-1000 coins, equip system, real-time home preview sync

### 📈 Progression
- **Daily Reward**: 7-day cycle [50,75,100,150,200,300,500] with streak logic (isSameDay, isYesterday, reset)
- **Achievements (10)**: First Flight, Soaring 10, Pilot 25, Ace 50, Legend 100, Collector 100/500 coins, Persistent 10/50 games, Flappy Master 500 flaps — rewards coins
- **Leaderboard**: Local top 50, podium for top 3, date formatting with intl
- **Coin economy**: Starter 50, per pipe 1, per coin 1, rewarded ad fallback

### 🎨 Premium UI
- **Glassmorphism**: `BackdropFilter.blur 18`, 14% opacity, white 18% border
- **Material 3** + dark premium palette (#0A0E21 background, #6C5CE7 primary)
- **Animations**: `flutter_animate` — fade, slide, scale elastic, shimmer, moveY hover
- Buttons: scale on press 0.92, shadow 18 blur, gradient

### 🔧 Services
- **Storage**: `GetStorage` wrapper `StorageService` with defaults, typed getters (highScore, totalCoins, unlocked lists)
- **Audio**: `flame_audio` pool, BGM main/game, SFX flap/coin/score/hit/die/button with mute respect
- **Haptics**: light/medium/heavy/selection respecting setting
- **Ads Ready**: `google_mobile_ads` — banner, interstitial, rewarded with crash-proof init, test IDs included, manifest snippet provided

### 🏛️ Architecture
- **Feature-first**: `features/game, home, shop, settings, achievements, leaderboard, daily_reward`
- **Clean**: domain/entities, domain/repositories, data/datasources, data/repositories, presentation/controllers/pages/widgets
- **SOLID**: single responsibility services, repository abstraction, DI via `InitialBinding` fenix true
- **No warnings**, null safety, no deprecated APIs for 3.24.5 (CardTheme, DialogTheme)

### 🌐 Localization Ready
- `flutter_localizations` + `l10n.yaml` with `generate: true`
- ARBs: `app_en.arb`, `app_es.arb` in `assets/l10n/`
- Supported: en, es, fr, de, hi — easy to add more

---

## 🧩 Tech Stack & Packages

| Package | Version | Purpose |
|---|---|---|
| **flame** | ^1.22.0 | Game loop, components, collisions, camera |
| **flame_audio** | ^2.7.5 | BGM & SFX pooling, pre-cache |
| **get** | ^4.6.6 | State (Rx), routing, DI Bindings |
| **get_storage** | ^2.1.1 | Fast local persistence |
| **google_mobile_ads** | ^5.2.0 | Banner / Interstitial / Rewarded (test IDs) |
| **google_fonts** | ^6.2.1 | Poppins (UI) + Fredoka (score/coin) |
| **flutter_animate** | ^4.5.2 | Premium fade/slide/scale/shimmer without controllers |
| **flutter_staggered_animations** | ^1.1.1 | Grid entrance |
| **shared_preferences** | ^2.3.2 | Fallback if needed |
| **package_info_plus** | ^8.0.0 | Version info |
| **device_info_plus** | ^10.1.0 | Device info |
| **intl** | ^0.20.1 | Date formatting leaderboard |
| **equatable** | ^2.0.7 | Value equality entities |
| **uuid** | ^4.5.1 | IDs |
| `flutter_localizations` | SDK | i18n |

**Why this stack?**
- **Flame + flame_audio**: Industry standard for 2D Flutter games, 60fps, collision system
- **GetX**: One package for state, navigation, DI — reduces boilerplate, fenix keeps controllers alive
- **GetStorage**: Sync, no async boilerplate like SharedPreferences for game data

---

## 📁 Project Structure

```
lib/
  app/
    bindings/initial_binding.dart   # DI: Storage, Audio, Haptics, Controllers
    routes/app_routes.dart, app_pages.dart
    theme/app_colors.dart, app_text_styles.dart, app_theme.dart
  core/
    constants/app_constants.dart, asset_constants.dart
    enums/character_type, theme_type, game_state
    error/failures.dart (Result pattern)
    services/storage_service, audio_service, haptic_service, ads_service
    utils/helpers.dart (random, chance, isSameDay)
    widgets/glassmorphic_container, premium_button, coin_display
  features/
    game/
      domain/entities/score_entry, achievement
      domain/repositories/game_repository
      data/datasources/local_datasource, repositories/game_repository_impl
      presentation/game/fluttery_game.dart (+ callbacks onGameStarted)
      presentation/game/components/bird, pipe, coin, ground, parallax
      presentation/controllers/game_controller
      presentation/pages/game_page.dart (WATCH AD → TAP TO FLAP → resume at score 3)
    home/presentation/pages/home_page, widgets/home_background, animated_bird_preview
    shop/presentation/pages/shop_page, widgets/shop_item_card, controllers/shop_controller (real-time sync to home)
    settings, achievements, leaderboard, daily_reward...
  l10n/
  main.dart (runZonedGuarded, edge-to-edge, delayed ads init)
assets/
  images/ui/app_icon.png
  l10n/app_en.arb, app_es.arb
  screenshots/
```

---

## 🚀 Getting Started

```bash
# 1. Get deps (fixed: generate:true + flame_parallax removed)
flutter clean
flutter pub get

# 2. Add AdMob App ID to Android (otherwise auto-close on launch)
# android/app/src/main/AndroidManifest.xml inside <application>:
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="ca-app-pub-3940256099942544~3347511713"/>

# 3. Run
flutter run

# 4. Build Play Store
flutter build appbundle --release
```

---

## 🎯 How to Play & Flows

**Core**: Tap to flap, avoid pipes, collect coins

**Flows implemented per your spec:**
- `Score 3 → Die → WATCH AD → ad closes → TAP TO FLAP (keeps 3) → tap → resumes at 3, safe spot`
- `Score 3 → Pause → RESUME → TAP TO FLAP (keeps 3) → tap → resumes at 3`
- `Play → Pause → RESTART → TAP TO FLAP → tap → new game from 0`

**Shop**: Earn coins → buy character/theme → home preview updates **real-time** (no restart needed) via `ShopController._syncHome()` pushing to `HomeController`.

---

## ⚙️ Game Tuning (AppConstants)

```dart
gravity = 920, flap = -360, maxFall = 460
pipeWidth = 78, gap = 158, spacing = 280
baseSpeed = 180, maxSpeed = 340, speedInc = 1.8 per score
coinSize = 28, spawnChance = 0.62
dailyRewards = [50,75,100,150,200,300,500]
```

Characters have `flapBoost` and `gravityModifier` (Phoenix 1.12/0.9).

---

## 📱 Ads Setup (AdMob IDs)

This project uses **google_mobile_ads 5.2.0** with crash-proof `AdsService`. Test ads work out of the box, but you MUST add your App IDs before Play Store release or app will auto-close on launch.

### 1️⃣ What is what?

| ID Type | Example | Where to use | Where to get |
|---|---|---|---|
| **App ID** | `ca-app-pub-3940256099942544~3347511713` | `AndroidManifest.xml` + `Info.plist` (one per app) | AdMob Console → Apps → App settings |
| **Ad Unit IDs** | `ca-app-pub-3940.../6300978111` (banner), `/1033173712` (interstitial), `/5224354917` (rewarded) | `AppConstants` in Dart code | AdMob Console → Apps → Ad Units |
| **Test IDs** | Same as above with `3940...` are Google's test IDs | Already in project, safe for dev | Google docs |

> **App ID** has a `~` tilde, **Ad Unit ID** has `/` slash. Don't mix them!

### 2️⃣ Step 1 — Replace Ad Unit IDs in Dart

`lib/core/constants/app_constants.dart`:
```dart
static const String testBannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';
static const String testInterstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712';
static const String testRewardedAdUnitId = 'ca-app-pub-3940256099942544/5224354917';
```
Replace with your real IDs for release:
```dart
static const String bannerAdUnitId = 'ca-app-pub-YOUR_REAL_ID/XXXXXXXXXX';
```

### 3️⃣ Step 2 — Android Manifest (REQUIRED or app crashes)

`android/app/src/main/AndroidManifest.xml` inside `<application>` tag:

```xml
<manifest>
    <application
        android:label="Fluttery Wings"
        android:name="${applicationName}"
        android:icon="@mipmap/launcher_icon">
        
        <!-- ADD THIS - Test App ID, replace with yours for release -->
        <meta-data
            android:name="com.google.android.gms.ads.APPLICATION_ID"
            android:value="ca-app-pub-3940256099942544~3347511713"/>

        <activity ...>
        </activity>
    </application>
</manifest>
```

If you miss this, logcat shows: `The Google Mobile Ads SDK was initialized incorrectly`.

### 4️⃣ Step 3 — iOS Info.plist (for iOS build)

`ios/Runner/Info.plist`:

```xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-3940256099942544~3347511713</string>
<key>io.flutter.embedded_views_preview</key>
<true/>
```

### 5️⃣ Step 4 — How code uses it

`lib/main.dart` does delayed init (800ms after first frame) so launch is never blocked:

```dart
Future.delayed(800.ms, () => AdsService.instance.init());
```

`lib/core/services/ads_service.dart`:
- `createBannerAd()` → for future banner in shop/home
- `showInterstitialIfReady()` → after game over sometimes
- `showRewardedAd(onRewarded: (amount){ add coins })` → WATCH AD button → revives at score 3

All methods are `try/catch` — if manifest missing or ad not ready, app continues, no crash.

### 6️⃣ Test vs Production

- **Dev**: Keep test IDs, you will see Google test ads "Test Ad"
- **Release**: Replace ALL test IDs with your real ones from AdMob, and `APPLICATION_ID`. Test on real device with `flutter run --release` to ensure no crash.

Detailed fix doc: See `ANDROID_FIX.md` and `android_manifest_snippet.xml` in repo.

---

## 🌍 Localization

Add new ARB in `assets/l10n/` e.g., `app_hi.arb`:
```json
{"@@locale":"hi","appName":"फ्लटरी विंग्स","playNow":"अब खेलें"}
```
`flutter gen-l10n` will generate.

---

## ✅ Play Store Checklist

- [ ] Replace test AdMob IDs
- [ ] Add real `app_icon.png` 1024x1024
- [ ] Add audio files in `assets/audio/` (flap.wav, coin.wav...)
- [ ] `flutter build appbundle`
- [ ] Privacy policy, target SDK 34
- [ ] Test on real device (ads, haptics)

---

## 🐛 Known Fixes Done

- `l10n` generate error → added `flutter: generate: true` + ARB files
- `flame_parallax` not found → removed (parallax is custom procedural)
- `CardThemeData` not defined on 3.24.5 → use `CardTheme`
- `shimmer(enabled:)` → conditional shimmer
- Coin collision = Game Over → filtered `CoinComponent` in `_handleCollision`
- Coins on pipes → single `topHeight` reused for pipe+coin, 28px safe margin
- TAP TO FLAP not hiding → added `onGameStarted` callback
- TAP TO FLAP not tappable after pause → full-screen `GestureDetector` + `IgnorePointer` on HUD
- RESTART stuck → `resetToReady()` before `startGame()`
- Shop not updating home realtime → `_syncHome()` pushes Rx to HomeController

---

## 📄 License

MIT — feel free to publish.

Made with 💜 premium glassmorphism + AAA game feel.
