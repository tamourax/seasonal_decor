# seasonal_decor

Drop-in seasonal decorative overlays for Flutter apps. Ships with a lightweight **CustomPainter + Ticker** particle engine and ready-to-use presets for **Ramadan, Eid, Christmas, New Year, Valentine, Halloween, and Sport Event**.

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  seasonal_decor: ^1.1.2
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
  intensity: DecorIntensity.high,
  opacity: 0.9,
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
  backdropType: BackdropType.bunting,
  backdropAnchor: const Offset(0.5, 0.12), // position (x,y)
  backdropSizeFactor: 0.08, // size
);

SeasonalDecor(
  preset: preset,
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

## Options

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

### Preset Overrides

All presets can be customized using `withOverrides(...)` to swap shapes or backdrops.

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
