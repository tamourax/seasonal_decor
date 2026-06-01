# seasonal_decor - Detailed Package Description

## 1) What this package is

`seasonal_decor` is a Flutter UI overlay package that adds themed particle animations and decorative backdrops on top of any widget.

Main goals:
- Fast one-line integration (`SeasonalDecor(...)`).
- Ready seasonal presets (Ramadan, Eid, Christmas, New Year, Valentine, Halloween, Football, None).
- Runtime customization without rebuilding the whole animation system.
- Accessibility and lifecycle safety (reduce motion + pause when app is inactive).

Current package version in `pubspec.yaml`: `1.4.0`.

## 2) Public API surface

Main library export: `lib/seasonal_decor.dart`.

Key public types:
- `SeasonalDecor` widget (main entry point).
- `SeasonalPreset` factories (`ramadan`, `eid`, `christmas`, `newYear`, `valentine`, `halloween`, `football`, `none`).
- `DecorIntensity` (`low`, `medium`, `high`, `extraHigh`, `max`).
- `DecorConfig`, `ParticleStyle`, `DecorBackdrop`, `BackdropType`, `BackdropLayer`.
- `ParticleShape` enum.
- Variant enums (`RamadanVariant`, `EidVariant`, etc).

## 3) High-level architecture

Directory layout:
- `lib/src/widgets/seasonal_decor.dart`: widget state machine, timers, lifecycle, text logic, config resolution.
- `lib/src/engine/decor_controller.dart`: ticker-driven update orchestration.
- `lib/src/engine/particle_system.dart`: particle pool, spawn/update/wrap/respawn/fireworks simulation.
- `lib/src/engine/decor_painter.dart`: all drawing logic (particles + backdrops).
- `lib/src/config/*`: immutable configuration models and intensity profiles.
- `lib/src/presets/*`: preset-specific base configs.
- `lib/src/utils/*`: lifecycle pause + reduce-motion detection.

Runtime pipeline:
1. `SeasonalDecor` resolves a final `DecorConfig` from preset + intensity + overrides.
2. `DecorController` owns a ticker and a single `ParticleSystem` instance.
3. Each tick updates particles in `ParticleSystem.update(dt)`.
4. `DecorPainter` paints two layers:
   - Backdrop layer (can be cached as `ui.Picture` for performance).
   - Particle layer (repaints each tick).

## 4) Configuration resolution order

In `SeasonalDecor`, config is built in this order:
1. Start from preset base config.
2. Apply intensity profile (`particleCount`, speed, spawn rates).
3. Apply preset overrides (shapes/styles/backdrop/fireworks toggles).
4. Apply runtime multipliers (`particleSpeedMultiplier`, `particleSizeMultiplier`).
5. Apply optional theme adaptation (`adaptColorsToTheme`).
6. Apply backdrop-layer visibility filtering (`showBackgroundBackdrops`, `showDecorativeBackdrops`, `backgroundBackdrop`).

This order matters because users can combine coarse controls (preset/intensity) with fine controls (style overrides, multipliers).

## 5) Playback model

`SeasonalDecor` playback is timer-based:
- `playDuration`: how long each active run lasts.
- `repeatEvery`: optional delay before replaying another run.
- `settleOnDisable`: if true, particles can finish naturally when stopping.

Important behavior:
- Fireworks presets force respawn on restart to avoid delayed-looking rockets.
- If `preset == none`, widget returns child directly (no overlay/ticker work).

## 6) Text overlay behavior

Greeting text is tri-state via `showText`:
- `showText: true`: show default preset message when custom text is empty.
- `showText: false`: always hide text.
- `showText: null` (omitted): show only when custom non-empty `text` is supplied.

Text timing behavior:
- First text cycle starts after first frame (smoother startup).
- Enter animation completes, then hold for `textDisplayDuration`, then exit.
- Pause/resume preserves pending hide timing.
- Arabic detection switches direction to RTL and enforces safe letter spacing.

## 7) Presets and visual style

Implemented preset builders:
- `ramadan.dart`: `classic`, `night`, `hangingLanterns`.
- `eid.dart`: `fitr`, `adha`, `classic` alias.
- `christmas.dart`: `classic`.
- `new_year.dart`: `fireworks`, `gold`.
- `valentine.dart`: `hearts`, `minimal`.
- `halloween.dart`: `spooky`, `pumpkin`.
- `football.dart`: `worldCup`.

Notable preset details:
- Fireworks enabled in `EidVariant.adha` and New Year variants.
- Football is ball-based and fireworks-off.
- Ramadan classic uses `ramadanBunting`; hanging lanterns adds `ramadanLights` + lantern backdrop.

## 8) Performance strategy

Performance choices visible in code:
- Object pooling: fixed particle list reused; avoids per-frame allocations.
- Incremental active-particle counting (fewer full scans in hot loop).
- Config soft-update path keeps same `ParticleSystem` instance when possible.
- Split paint layers: static backdrop separate from animated particles.
- Backdrop picture cache in painter with bounded cache (`_maxBackdropCacheEntries = 24`).
- Delta clamp in updates (`dt` clamped to 50ms max) for stability on frame drops.

## 9) Accessibility and app lifecycle

Supported behaviors:
- `respectReduceMotion` uses `MediaQuery.disableAnimations`.
- `pauseWhenInactive` pauses animation via `WidgetsBindingObserver` helper.
- `ignorePointer` defaults to true so taps pass through overlay.

## 10) Test coverage summary

Current test suite covers:
- Core particle behavior, wrapping/respawn, fireworks bursts.
- Config equality/hash to avoid redundant runtime updates.
- DecorController update behavior (soft/hard/identical updates).
- Spawn accumulator regression around empty->non-empty style transitions.
- Widget behaviors: repeat cycles, text visibility/timing, RTL text, backdrop layering.
- Transition stress tests (rapid toggles, preset switching, none<->preset).
- Golden snapshots (`test/golden_test.dart`) for major scenes.
- Coarse performance budget check for update loop.

## 11) Extension guide for maintainers

How to add a new seasonal preset:
1. Add a variant enum and `buildXConfig(...)` in `lib/src/presets/`.
2. Register factory in `SeasonalPreset`.
3. Use existing `ParticleShape` or add a new shape + painter branch.
4. Add default text mapping in `_defaultTextForPreset` if needed.
5. Add unit/widget tests for preset behavior.
6. Add preview GIF and README table entry.

How to add a new backdrop type:
1. Add enum value in `BackdropType`.
2. Add convenience constructor in `DecorBackdrop`.
3. Implement drawing branch in `DecorPainter._paintBackdropItem`.
4. Add tests to confirm layer filtering and rendering path.

## 12) Practical usage recommendations

- Use `DecorIntensity.medium` or `high` for persistent screens.
- Use `extraHigh`/`max` mainly for short celebration moments.
- Keep `respectReduceMotion: true` and `pauseWhenInactive: true` in production.
- For static festive themes, disable particles (`presetShapes: []`) and keep backdrop visible.

## 13) Known constraints

- Particle visuals are random by design; golden tests use tolerance.
- Very high intensity + large screens can still raise GPU/CPU cost.
- `DecorPainter` is large and shape-heavy; adding many new vector shapes should be done carefully with profiling.

## 14) Quick commands

Run package tests:
```bash
flutter test
```

Run example (simple):
```bash
flutter run -t example/lib/main.dart
```

Run example (advanced controls):
```bash
flutter run -t example/lib/advanced_main.dart
```
