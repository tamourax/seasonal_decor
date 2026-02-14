# seasonal_decor

![Live Demo](assets/demo.gif)

[![Flutter](https://img.shields.io/badge/Flutter-3.16%2B-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Pub Version](https://img.shields.io/pub/v/seasonal_decor?logo=dart&logoColor=white)](https://pub.dev/packages/seasonal_decor)
![Production Ready](https://img.shields.io/badge/Production-Ready-16a34a)

Add beautiful seasonal animations and festive overlays to your Flutter app with one line of code.

Bring Ramadan vibes, Christmas magic, Valentine effects, New Year celebrations, and more instantly.

**Install with one command: `flutter pub add seasonal_decor`**

## ✨ Features

- 🎄 Christmas snow and festive decorations
- 🌙 Ramadan lanterns and crescents
- 🎉 Eid balloons and sparkles
- 🎃 Halloween particles and spooky mood
- ❤️ Valentine hearts
- 🎆 New Year fireworks and confetti
- 🏆 Sports celebration mode
- 🌗 Light and dark theme adaptation
- 📱 Android, iOS, Web, Windows, macOS, Linux
- 🎛 Control intensity, speed, size, and backdrop layers
- 💬 Animated greeting text (`showText`, `text`, `textOpacity`)

## 🚀 Quick Start

```dart
SeasonalDecor(
  preset: SeasonalPreset.ramadan(),
  intensity: DecorIntensity.medium,
  child: const HomeScreen(),
);
```

That is it. Instant festive UI.

## ✅ Recommended Setup

```dart
SeasonalDecor(
  preset: SeasonalPreset.ramadan(),
  intensity: DecorIntensity.high,
  playDuration: const Duration(seconds: 8),
  repeatEvery: const Duration(minutes: 2),
  showBackdrop: true,
  showText: true,
  textOpacity: 0.5,
  particleSpeedMultiplier: 1.1,
  adaptColorsToTheme: true,
  child: const HomeScreen(),
);
```

Recommended defaults for most apps:

- Keep `respectReduceMotion: true` (default)
- Keep `pauseWhenInactive: true` (default)
- Use `intensity: DecorIntensity.medium/high` for daily screens
- Use `high/extraHigh/max` only for short celebration moments

## 🎮 Interactive Demo Controls

In the example app, users can interact with:

- Preset picker and intensity controls
- `repeatEvery` and play duration
- Backdrop visibility by layer (background/decorative)
- Greeting text toggle, text input, and text animation controls
- Reduce-motion behavior and simulation

## 🎨 Available Presets

- `SeasonalPreset.ramadan()`
- `SeasonalPreset.ramadan(variant: RamadanVariant.hangingLanterns)` (new)
- `SeasonalPreset.eid()`
- `SeasonalPreset.christmas()`
- `SeasonalPreset.newYear()`
- `SeasonalPreset.valentine()`
- `SeasonalPreset.halloween()`
- `SeasonalPreset.football()` (`sportEvent()` still works as alias)
- `SeasonalPreset.none()`

## 🎬 Preset GIF Previews

If GIFs do not render in your mirror/CDN, open files directly from `assets/gif/`.

| Ramadan | Eid al-Fitr | Eid al-Adha |
| --- | --- | --- |
| ![Ramadan](assets/gif/ramadan.gif) | ![Eid al-Fitr](assets/gif/eid_fitr.gif) | ![Eid al-Adha](assets/gif/eid-adha.gif) |

| Christmas | Valentine | New Year |
| --- | --- | --- |
| ![Christmas](assets/gif/christmas.gif) | ![Valentine](assets/gif/valentine.gif) | ![New Year](assets/gif/new-year.gif) |

## 🎛 Customization

```dart
SeasonalDecor(
  preset: SeasonalPreset.christmas(),
  intensity: DecorIntensity.high,
  particleSpeedMultiplier: 1.2,
  particleSizeMultiplier: 1.1,
  showBackdrop: true,
  showBackgroundBackdrops: true,
  showDecorativeBackdrops: true,
  showText: true,
  textOpacity: 0.5,
  repeatEvery: const Duration(minutes: 2),
  child: const HomeScreen(),
);
```

## ⚔️ Why Not Just Confetti ?

| Feature                      | `seasonal_decor` | `confetti`-style package |
| ---------------------------- | ---------------- | ------------------------ |
| Seasonal presets             | Yes              | No                       |
| Decorative backdrops         | Yes              | No                       |
| One-line setup               | Yes              | Limited                  |
| Theme adaptive               | Yes              | No                       |
| Greeting text overlay        | Yes              | No                       |
| Layer-level backdrop control | Yes              | No                       |

## 🌍 Live Demo

[Live Demo](https://tamourax.github.io/seasonal_decor/)

## 📦 Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  seasonal_decor: ^1.2.1
```

Then run:

```bash
flutter pub get
```

Or simply:

```bash
flutter pub add seasonal_decor
```

## 🧪 Quick Recipes

Confetti only (disable fireworks in New Year):

```dart
SeasonalDecor(
  preset: SeasonalPreset.newYear(),
  presetEnableFireworks: false,
  child: const HomeScreen(),
);
```

Backdrop only:

```dart
SeasonalDecor(
  preset: SeasonalPreset.ramadan(),
  presetShapes: const <ParticleShape>[],
  showBackdrop: true,
  child: const HomeScreen(),
);
```

Greeting text with default seasonal message:

```dart
SeasonalDecor(
  preset: SeasonalPreset.ramadan(),
  showText: true,
  textOpacity: 0.5, // default
  child: const HomeScreen(),
);
```

Custom message:

```dart
SeasonalDecor(
  preset: SeasonalPreset.eid(variant: EidVariant.adha),
  showText: true,
  text: 'Eid Mubarak',
  textStyle: const TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w700,
  ),
  textDisplayDuration: const Duration(seconds: 2),
  textAnimationDuration: const Duration(milliseconds: 550),
  child: const HomeScreen(),
);
```

Custom background backdrop widget:

```dart
SeasonalDecor(
  preset: SeasonalPreset.ramadan(),
  showBackdrop: true,
  backgroundBackdrop: Align(
    alignment: const Alignment(0.85, -0.7),
    child: Icon(Icons.nightlight_round, size: 180, color: Color(0x66FFE2A6)),
  ),
  child: const HomeScreen(),
);
```

## ⚙️ Core Options (Quick Table)

| Option                                | Default  | Description                                            |
| ------------------------------------- | -------- | ------------------------------------------------------ |
| `enabled`                             | `true`   | Show/hide overlay.                                     |
| `intensity`                           | `medium` | Particle count and base speed profile.                 |
| `opacity`                             | `1.0`    | Global overlay opacity.                                |
| `showBackdrop`                        | `true`   | Render backdrop graphics.                              |
| `showBackgroundBackdrops`             | `true`   | Toggle built-in background backdrop layer.             |
| `showDecorativeBackdrops`             | `true`   | Toggle decorative backdrop layer.                      |
| `backgroundBackdrop`                  | `null`   | Custom widget replacing built-in background backdrops. |
| `showText`                            | `false`  | Show animated greeting text.                           |
| `textOpacity`                         | `0.5`    | Greeting text opacity multiplier.                      |
| `particleSpeedMultiplier`             | `1.0`    | Runtime speed scale.                                   |
| `particleSizeMultiplier`              | `1.0`    | Runtime size scale.                                    |
| `decorativeBackdropDensityMultiplier` | `1.0`    | Decorative backdrop detail density scale.              |
| `playDuration`                        | `5s`     | Playback duration per cycle.                           |
| `repeatEvery`                         | `null`   | Optional replay interval.                              |

## 🧪 Example

Run example app:

```bash
flutter run -t example/lib/main.dart
```

Run advanced demo:

```bash
flutter run -t example/lib/advanced_main.dart
```

## 📄 License

MIT License. See [LICENSE](LICENSE).
