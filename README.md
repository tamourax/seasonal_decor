# seasonal_decor

Drop-in seasonal decorative overlays for Flutter apps. Ships with a lightweight **CustomPainter + Ticker** particle engine and ready-to-use presets for **Ramadan, Eid, Christmas, New Year, Valentine, Halloween, and Sport Event**.

Repository: https://github.com/tamourax/seasonal_decor

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  seasonal_decor: ^0.1.0
```

Then run:

```bash
flutter pub get
```

## Quick Start

```dart
SeasonalDecor(
  preset: SeasonalPreset.ramadan(),
  intensity: DecorIntensity.medium,
  child: const HomeScreen(),
);
```

## Options

| Option                | Type             | Default  | Description                            |
| --------------------- | ---------------- | -------- | -------------------------------------- |
| `child`               | `Widget`         | required | Widget below the overlay.              |
| `preset`              | `SeasonalPreset` | required | Decorative preset to render.           |
| `enabled`             | `bool`           | `true`   | Shows or hides the overlay.            |
| `intensity`           | `DecorIntensity` | `medium` | Particle count, speed, spawn rate.     |
| `opacity`             | `double`         | `1.0`    | Global overlay opacity (0.0 to 1.0).   |
| `respectReduceMotion` | `bool`           | `true`   | Honors `MediaQuery.disableAnimations`. |
| `pauseWhenInactive`   | `bool`           | `true`   | Pauses animation when app is inactive. |
| `ignorePointer`       | `bool`           | `true`   | Lets taps pass through the overlay.    |

## Presets

- Ramadan (`classic`, `night`)
- Eid (`classic`) � fireworks rockets and bursts
- Christmas (`classic`) � snow with tree/garland
- New Year (`fireworks`, `gold`) � fireworks with confetti
- Valentine (`hearts`, `minimal`) � floating hearts with sparkles
- Halloween (`spooky`, `pumpkin`) � bats/pumpkins with moon
- Sport Event (`worldCup`, `teamColors`) � trophy + celebration

## Performance Notes

- Fixed-size particle pool with reuse.
- Adaptive density scaling based on screen area.
- RepaintBoundary isolates the overlay.
- Optional pause on inactive lifecycle states.

## Accessibility

- If `respectReduceMotion` is true and `MediaQuery.disableAnimations` is enabled, the overlay renders a static decoration instead of animating.

## Supported Platforms

- Android
- iOS
- Web
- Windows
- macOS
- Linux

## Example

See `example/lib/main.dart` for a full demo with presets and controls.

## License

MIT License. See [LICENSE](LICENSE).
