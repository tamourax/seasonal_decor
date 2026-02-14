# seasonal_decor

![Live Demo](https://raw.githubusercontent.com/tamourax/seasonal_decor/main/assets/demo.gif)

[![Flutter](https://img.shields.io/badge/Flutter-3.16%2B-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Pub Version](https://img.shields.io/pub/v/seasonal_decor?logo=dart&logoColor=white)](https://pub.dev/packages/seasonal_decor)
![Production Ready](https://img.shields.io/badge/Production-Ready-16a34a)

Seasonal overlays for Flutter apps - Ramadan, Eid, Christmas, New Year, Valentine, Halloween, and more.

Add beautiful seasonal particle effects to your Flutter app in one line of code.

**Try the Live Demo above or install with one line: `flutter pub add seasonal_decor`**

## Live Demo

[Live Demo](https://tamourax.github.io/seasonal_decor/)
Published from the `live-demo` branch to keep the package branch lightweight.

## Releases

- GitHub Releases: https://github.com/tamourax/seasonal_decor/releases
- Latest release notes draft: `release_notes/v1.1.5.md`

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  seasonal_decor: ^1.1.5
```

Then run:

```bash
flutter pub get
```

Or simply:

```bash
flutter pub add seasonal_decor
```

## Quick Start

```dart
SeasonalDecor(
  preset: SeasonalPreset.ramadan(),
  intensity: DecorIntensity.medium,
  child: const HomeScreen(),
);
```

## Scene Modes + Moments

```dart
final decorController = SeasonalDecorController();

SeasonalDecor(
  preset: SeasonalPreset.newYear(),
  mode: SeasonalMode.ambient, // or SeasonalMode.festive
  controller: decorController,
  child: const HomeScreen(),
);
```

Trigger short celebration moments:

```dart
decorController.trigger(SeasonalMoment.greetingBurst);
decorController.trigger(
  SeasonalMoment.fireworksBurst,
  options: const SeasonalMomentOptions(
    intensity: 0.8,
    origin: Offset(0.5, 0.35),
  ),
);
```

## Examples

### Basic

```dart
SeasonalDecor(
  preset: SeasonalPreset.christmas(),
  child: const HomeScreen(),
);
```

### Medium (Common Controls)

```dart
SeasonalDecor(
  preset: SeasonalPreset.eid(variant: EidVariant.fitr),
  intensity: DecorIntensity.high,
  particleSpeedMultiplier: 1.3,
  showBackdrop: true,
  adaptColorsToTheme: true,
  child: const HomeScreen(),
);
```

### Advanced (Preset Overrides)

```dart
SeasonalDecor(
  preset: SeasonalPreset.ramadan(),
  intensity: DecorIntensity.max,
  presetShapes: const [ParticleShape.lantern, ParticleShape.crescent],
  presetShapeSpeedMultipliers: const {
    ParticleShape.lantern: 1.25,
  },
  presetBackdropType: BackdropType.crescent,
  presetBackdropAnchor: const Offset(0.8, 0.2),
  presetBackdropSizeFactor: 0.3,
  repeatEvery: const Duration(minutes: 10),
  child: const HomeScreen(),
);
```

## Quick Comparison

Comparison against a typical confetti package (exact features vary by package/version):

| Feature | `seasonal_decor` | `confetti`-style package |
| --- | --- | --- |
| One-line seasonal preset setup | Yes | No |
| Built-in Ramadan/Eid/Christmas/New Year presets | Yes | No |
| Decorative backdrops (crescent/tree/garland/mosque/trophy) | Yes | No |
| Intensity levels (`low` to `max`) | Yes | Varies |
| Runtime speed control (`particleSpeedMultiplier`) | Yes | Varies |
| Light/Dark theme color adaptation | Yes | Varies |
| Timed play with optional auto-repeat | Yes | Varies |
| Keep backdrop visible while particles are disabled | Yes | No |
| Advanced demo screen with live controls | Yes | Varies |

## Quick Recipes

Confetti only (disable fireworks in New Year preset):

```dart
SeasonalDecor(
  preset: SeasonalPreset.newYear(),
  presetEnableFireworks: false,
  child: const HomeScreen(),
);
```

Backdrop only (no particles):

```dart
SeasonalDecor(
  preset: SeasonalPreset.ramadan(),
  presetShapes: const <ParticleShape>[],
  showBackdrop: true,
  child: const HomeScreen(),
);
```

Double speed:

```dart
SeasonalDecor(
  preset: SeasonalPreset.christmas(),
  particleSpeedMultiplier: 2.0,
  child: const HomeScreen(),
);
```

Static backdrop mode (keep decor while animation is disabled):

```dart
SeasonalDecor(
  preset: SeasonalPreset.eid(variant: EidVariant.adha),
  enabled: false,
  showBackdrop: true,
  showBackdropWhenDisabled: true,
  child: const HomeScreen(),
);
```

## Easy Usage

Basic overlay:

```dart
SeasonalDecor(
  preset: SeasonalPreset.christmas(),
  child: const HomeScreen(),
);
```

No overlay (render child only):

```dart
SeasonalDecor(
  preset: SeasonalPreset.none(),
  child: const HomeScreen(),
);
```

Control intensity and opacity:

```dart
SeasonalDecor(
  preset: SeasonalPreset.eid(),
  intensity: DecorIntensity.max,
  opacity: 0.9,
  child: const HomeScreen(),
);
```

Control speed and theme-aware colors:

```dart
SeasonalDecor(
  preset: SeasonalPreset.newYear(),
  intensity: DecorIntensity.extraHigh,
  particleSpeedMultiplier: 1.4,
  adaptColorsToTheme: true,
  child: const HomeScreen(),
);
```

Timed playback with optional auto-repeat:

```dart
SeasonalDecor(
  preset: SeasonalPreset.sportEvent(),
  playDuration: const Duration(seconds: 8),
  repeatEvery: const Duration(minutes: 10),
  settleOnDisable: true,
  showBackdrop: true,
  child: const HomeScreen(),
);
```

Customize particle shapes and backdrops:

```dart
final preset = SeasonalPreset.eid(variant: EidVariant.fitr).withOverrides(
  shapes: [ParticleShape.balloon],
  shapeSpeedMultipliers: {ParticleShape.balloon: 1.3},
  backdropType: BackdropType.bunting,
  backdropAnchor: const Offset(0.5, 0.12), // position (x,y)
  backdropSizeFactor: 0.08, // size
);

SeasonalDecor(
  preset: preset,
  child: const HomeScreen(),
);
```

Widget-level preset overrides (directly in `SeasonalDecor`):

```dart
SeasonalDecor(
  preset: SeasonalPreset.ramadan(),
  presetShapes: const [ParticleShape.lantern, ParticleShape.crescent],
  presetShapeSpeedMultipliers: const {
    ParticleShape.lantern: 1.25,
  },
  presetBackdropType: BackdropType.crescent,
  presetBackdropAnchor: const Offset(0.8, 0.2),
  presetBackdropSizeFactor: 0.3,
  child: const HomeScreen(),
);
```

## Advanced Example

```dart
SeasonalDecor(
  preset: SeasonalPreset.sportEvent(),
  playDuration: const Duration(seconds: 8),
  repeatEvery: const Duration(minutes: 10),
  settleOnDisable: true,
  showBackdrop: true,
  child: const HomeScreen(),
);
```

## Core Options (Quick Table)

| Option | Default | Description |
| --- | --- | --- |
| `enabled` | `true` | Show or hide overlay. |
| `intensity` | `medium` | Particle count and baseline speed. |
| `opacity` | `1.0` | Global overlay opacity. |
| `showBackdrop` | `true` | Render seasonal backdrop graphics. |
| `showBackdropWhenDisabled` | `true` | Keep backdrop visible when disabled. |
| `particleSpeedMultiplier` | `1.0` | Runtime speed scaling. |
| `adaptColorsToTheme` | `true` | Auto-tune colors for light/dark mode. |
| `playDuration` | `5s` | Duration of each play cycle. |
| `repeatEvery` | `null` | Optional automatic replay interval. |
| `settleOnDisable` | `true` | Let particles finish naturally on stop. |

## Full Options Reference

| Option                     | Type             | Default  | Description                            |
| -------------------------- | ---------------- | -------- | -------------------------------------- |
| `child`                    | `Widget`         | required | Widget below the overlay.              |
| `preset`                   | `SeasonalPreset` | required | Decorative preset to render.           |
| `enabled`                  | `bool`           | `true`   | Shows or hides the overlay.            |
| `intensity`                | `DecorIntensity` | `medium` | Particle count, speed, spawn rate.     |
| `opacity`                  | `double`         | `1.0`    | Global overlay opacity (0.0 to 1.0).   |
| `respectReduceMotion`      | `bool`           | `true`   | Honors `MediaQuery.disableAnimations`. |
| `pauseWhenInactive`        | `bool`           | `true`   | Pauses animation when app is inactive. |
| `ignorePointer`            | `bool`           | `true`   | Lets taps pass through the overlay.    |
| `playDuration`             | `Duration`       | `5s`     | How long the animation runs per cycle. |
| `settleOnDisable`          | `bool`           | `true`   | Let particles settle when stopping.    |
| `repeatEvery`              | `Duration?`      | `null`   | Auto-replay after the given duration.  |
| `showBackdrop`             | `bool`           | `true`   | Render decorative backdrops.           |
| `showBackdropWhenDisabled` | `bool`           | `true`   | Keep backdrops visible when disabled.  |
| `particleSpeedMultiplier`  | `double`         | `1.0`    | Multiplies particle/rocket/spark speed. |
| `adaptColorsToTheme`       | `bool`           | `true`   | Auto-adjusts colors for light/dark UI. |
| `presetShapes`             | `List<ParticleShape>?` | `null` | Overrides preset shapes from widget. |
| `presetStyles`             | `List<ParticleStyle>?` | `null` | Overrides full preset styles from widget. |
| `presetShapeSpeedMultipliers` | `Map<ParticleShape, double>?` | `null` | Per-shape speed overrides from widget. |
| `presetBackdrop`           | `DecorBackdrop?` | `null` | Overrides single preset backdrop. |
| `presetBackdrops`          | `List<DecorBackdrop>?` | `null` | Overrides preset backdrop list. |
| `presetBackdropType`       | `BackdropType?`  | `null` | Overrides backdrop type. |
| `presetBackdropAnchor`     | `Offset?`        | `null` | Overrides backdrop anchor. |
| `presetBackdropSizeFactor` | `double?`        | `null` | Overrides backdrop size. |
| `presetBackdropColor`      | `Color?`         | `null` | Overrides backdrop color. |
| `presetBackdropOpacity`    | `double?`        | `null` | Overrides backdrop opacity. |
| `presetEnableFireworks`    | `bool?`          | `null` | Overrides preset fireworks toggle. |

Notes:

- Use `playDuration: Duration.zero` for continuous animation.

### Option Details

`child`
The widget you want to decorate. The overlay is painted on top of this widget.

`preset`
Pick a ready-made style like Ramadan, Eid, Christmas, New Year, Valentine, Halloween, or Sport Event. Presets include shapes, colors, and backdrops.

You can use `SeasonalPreset.none()` to render the child without any decoration.

`enabled`
Turn the overlay on or off. When `false`, particles stop rendering. Backdrops can still show if `showBackdropWhenDisabled` is `true`.

`intensity`
Controls how many particles spawn and how fast they move. Use `low` for subtle effects, `high` for celebrations.
Available levels: `low`, `medium`, `high`, `extraHigh`, `max`.

`opacity`
Overall overlay opacity. Use lower values to keep UI readable.

`respectReduceMotion`
If the system has Reduce Motion enabled, the overlay renders a static decoration instead of animating.

`pauseWhenInactive`
Stops the animation when the app is paused or inactive to save resources.

`ignorePointer`
If `true`, the overlay does not block touches. Your UI remains fully interactive.

`playDuration`
How long each animation cycle runs. Use `Duration.zero` to keep it running continuously.

`settleOnDisable`
When stopping, existing particles keep moving and fall out naturally instead of disappearing instantly.

`repeatEvery`
Automatically replays the animation after the given time. Set to `null` to disable auto-repeat.

`showBackdrop`
Show or hide decorative backdrops like crescents, trees, garlands, or stadium elements.

`showBackdropWhenDisabled`
If `enabled` is `false`, this keeps the backdrop visible while particles remain hidden.

`particleSpeedMultiplier`
Adds direct speed control for particle falling/movement. Use values above `1.0` to speed up animation and below `1.0` to slow it down.

`adaptColorsToTheme`
When enabled, particle and backdrop colors are tuned for the current light/dark platform brightness to keep contrast and visibility consistent.

### Preset Overrides

All presets can be customized using `withOverrides(...)` to swap shapes or backdrops.

You can also apply the same override controls directly from `SeasonalDecor(...)` using:
`presetShapes`, `presetStyles`, `presetShapeSpeedMultipliers`, `presetBackdrop`,
`presetBackdrops`, `presetBackdropType`, `presetBackdropAnchor`,
`presetBackdropSizeFactor`, `presetBackdropColor`, `presetBackdropOpacity`,
and `presetEnableFireworks`.

Examples:
- Replace all particle shapes with balloons or sheep.
- Change the backdrop type (crescent/tree/garland/bunting/mosque/trophy).
- Change backdrop alignment using `backdropAnchor` (0..1) and size using `backdropSizeFactor`.

## Presets

- Ramadan (`classic`, `night`)
- Eid al-Fitr (`fitr`) - bunting + balloons
- Eid al-Adha (`adha`) - mosque + sheep + fireworks
- Christmas (`classic`) - snow with detailed tree, candy garland, ornaments, gifts
- New Year (`fireworks`, `gold`) - fireworks with confetti
- Valentine (`hearts`, `minimal`) - floating hearts with sparkles
- Halloween (`spooky`, `pumpkin`) - bats/pumpkins with moon
- Sport Event (`worldCup`, `teamColors`) - trophy + celebration

## Preset Previews

### **Ramadan**
```dart
SeasonalDecor(
  preset: SeasonalPreset.ramadan(),
  child: const HomeScreen(),
);
```
![Ramadan](https://raw.githubusercontent.com/tamourax/seasonal_decor/main/assets/gif/ramadan.gif)

### **Eid al-Fitr**
```dart
SeasonalDecor(
  preset: SeasonalPreset.eid(variant: EidVariant.fitr),
  child: const HomeScreen(),
);
```
![Eid al-Fitr](https://raw.githubusercontent.com/tamourax/seasonal_decor/main/assets/gif/eid_fitr.gif)

### **Eid al-Adha**
```dart
SeasonalDecor(
  preset: SeasonalPreset.eid(variant: EidVariant.adha),
  child: const HomeScreen(),
);
```
![Eid al-Adha](https://raw.githubusercontent.com/tamourax/seasonal_decor/main/assets/gif/eid-adha.gif)

### **Christmas**
```dart
SeasonalDecor(
  preset: SeasonalPreset.christmas(),
  child: const HomeScreen(),
);
```
![Christmas](https://raw.githubusercontent.com/tamourax/seasonal_decor/main/assets/gif/christmas.gif)

### **New Year**
```dart
SeasonalDecor(
  preset: SeasonalPreset.newYear(),
  child: const HomeScreen(),
);
```
![New Year](https://raw.githubusercontent.com/tamourax/seasonal_decor/main/assets/gif/new-year.gif)

### **Valentine**
```dart
SeasonalDecor(
  preset: SeasonalPreset.valentine(),
  child: const HomeScreen(),
);
```
![Valentine](https://raw.githubusercontent.com/tamourax/seasonal_decor/main/assets/gif/valentine.gif)

### **None**
```dart
SeasonalDecor(
  preset: SeasonalPreset.none(),
  child: const HomeScreen(),
);
```
![None](https://raw.githubusercontent.com/tamourax/seasonal_decor/main/assets/images/none.png)

## Performance

- Uses `CustomPainter`.
- Reuses particle pool.
- Respects Reduce Motion.
- Pauses when inactive.

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

See `example/lib/main.dart` for a simple demo.

For the full demo with presets and controls:

```bash
flutter run -t example/lib/advanced_main.dart
```

## License

MIT License. See [LICENSE](LICENSE).
