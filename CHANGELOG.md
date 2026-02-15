## 1.3.5

- Bump package version to `1.3.5`.
- Add value equality and `hashCode` support for `ParticleStyle`,
  `DecorBackdrop`, and `DecorConfig` to avoid unnecessary runtime updates.
- Optimize `DecorController.updateConfig(...)` with early return when config is
  unchanged, reducing redundant notifications/rebuild triggers.
- Fix spawn accumulator reset path for style transitions from empty to
  non-empty to prevent bursty first-frame spawning.
- Add focused regression coverage:
  `test/decor_config_equality_test.dart`,
  `test/spawn_accumulator_reset_test.dart`, and
  `test/decor_controller_update_config_test.dart`.
- Add golden validation suite (7 scenes) in `test/golden_test.dart`.
- Add transition and runtime stress coverage in
  `test/transition_stress_test.dart`.
- Add opt-in CI workflow `.github/workflows/perf_gate.yml` for analyze +
  unit/widget + golden + performance test gates.
- Add `RELEASE_CHECKLIST.md` and update `.gitignore` to keep golden failure
  screenshots out of git.

## 1.3.4

- Bump package version to `1.3.4`.
- Update greeting text visibility to tri-state `showText` behavior:
  explicit `false` hides text, explicit `true` enables preset defaults,
  and omitted `showText` only renders non-empty custom `text`.
- Keep greeting text one-shot per enabled run series when `repeatEvery`
  restarts playback cycles.
- Improve Arabic/web greeting rendering with explicit direction handling,
  `letterSpacing: 0` for Arabic text, and `TextDecoration.none`.
- Make greeting text animation more stable under jank:
  enter completes first, then hold for `textDisplayDuration`, then exit.
- Start the first greeting text cycle after the first rendered frame for a
  smoother startup.
- Keep text-hide timing consistent across app pause/resume to prevent
  bounce/reverse artifacts.
- Remove `BackdropType.mosque` from Ramadan `classic` and `night` variants.
- Performance optimization pass:
  split overlay painting into separate backdrop and particle layers to avoid
  repainting static backdrops on every animation tick.
- Add backdrop picture caching in `DecorPainter` for static backdrop-only
  passes (bounded cache with quantized size/opacity key).
- Improve `ParticleSystem` hot paths by tracking active particle count
  incrementally and avoiding repeated full-pool scans.
- Add a lightweight fast soccer-ball particle renderer while keeping the
  detailed football backdrop renderer.
- Reduce paint-time allocations by reusing temporary paths and precomputed
  tinted palettes in decorative backdrop loops.
- Support explicit backdrop-only override via
  `SeasonalPreset.withOverrides(shapes: const <ParticleShape>[])`.
- Add performance-focused tests in `test/performance_optimizations_test.dart`.
- Add text-position controls in the advanced example
  (`textAlignX`, `textAlignY`, `textTopPadding`).
- Refresh `example/pubspec.lock` path dependency version to `1.3.4`.

## 1.3.2

- Bump package version to `1.3.2`.
- Keep football naming only across the public API:
  remove `SeasonalPreset.sportEvent()`,
  rename `SportEventVariant` to `FootballVariant`,
  and rename `buildSportEventConfig(...)` to `buildFootballConfig(...)`.
- Align football preset labels/default text and tests with football-only naming.
- Update README install snippet to `1.3.2`.

## 1.3.1

- Bump package version to `1.3.1`.
- Keep pub.dev screenshots within the 10-image limit
  (remove `valentine.gif` and `football.gif` from `pubspec.yaml` screenshots).
- Add missing public API dartdoc comments for library/config constructors
  and fireworks rocket limits.
- Update README install snippet to `1.3.1`.

## 1.3.0

- Add `SeasonalPreset.football()` and keep `sportEvent()` as a deprecated alias.
- Replace sports visuals with football-first rendering:
  realistic football particles and `BackdropType.football`.
- Remove football team-color options and keep a classic black/white football palette.
- Disable fireworks in the football preset (balls-only behavior).
- Add Halloween pumpkin backdrop support via `BackdropType.pumpkin` and `DecorBackdrop.pumpkin(...)`.
- Improve decorative backdrop controls:
  add `decorativeBackdropRows` and `ramadanBuntingRows`.
- Refresh GIF assets and add new previews:
  `football.gif`, `halloween.gif`, and `ramadanLights.gif`.
- Move demo media to `assets/gif/demo.gif`, add `assets/images/logo.png`,
  and include the None preset preview image (`assets/images/none.png`).
- Update README preview media and installation snippet to `1.3.0`.

## 1.2.1

- Shorten package `description` in `pubspec.yaml` to satisfy pub points validation.
- Improve README media reliability by switching the hero preview to local `assets/gif/demo.gif`.
- Add explicit preset GIF gallery in README (`assets/gif/*.gif`) for stronger preview visibility on pub.dev.
- Update README install snippet to `1.2.1`.

## 1.2.0

- Add emotional seasonal greeting overlay text with animation support:
  `showText`, `text`, `textStyle`, `textOpacity`, `textAlignment`,
  `textPadding`, `textDisplayDuration`, `textAnimationDuration`,
  and `textSlideOffset`.
- Add layered backdrop customization:
  `showBackgroundBackdrops`, `showDecorativeBackdrops`,
  and `backgroundBackdrop` to replace built-in background backdrops
  with a custom widget.
- Add visual tuning controls:
  `particleSizeMultiplier` and `decorativeBackdropDensityMultiplier`.
- Improve fireworks repeat cycles so `repeatEvery` restarts feel immediate
  in presets like Eid al-Adha.
- Expand example apps (`main.dart` and `advanced_main.dart`) with full live
  controls for greeting text, backdrop layers, density, and size.
- Add/extend tests for text overlay behavior and backdrop layer composition.

## 1.1.6

- Improve runtime update performance by keeping the particle system instance
  stable and rebuilding the pool only when `particleCount` changes.
- Add incremental config application in `ParticleSystem` with
  soft/respawn/rebuild paths for lower churn during live updates.
- Add a safety contract in `setConfig`: debug assertion for mismatched pool
  size and graceful rebuild fallback in release mode.
- Tighten typed override documentation and add test coverage for typed
  `withOverrides(...)` inputs (shapes/styles/maps/backdrops).

## 1.1.5

- Improve `example/lib/advanced_main.dart` layout responsiveness for web and narrow screens.
- Update advanced demo defaults to:
  `SeasonalPreset.ramadan()`, `DecorIntensity.max`, dark mode, `opacity: 1.0`,
  `particleSpeedMultiplier: 2.0`, and `playDuration: 10s`.
- Refresh package docs for the new release metadata and release-notes link.

## 1.1.4

- Add two new intensity levels: `DecorIntensity.extraHigh` and `DecorIntensity.max`.
- Add `particleSpeedMultiplier` to control particle fall/motion speed at runtime.
- Add `adaptColorsToTheme` to tune particle/backdrop colors for light and dark UI.
- Improve light-mode backdrop visibility for subtle presets (like Ramadan crescent).
- Add per-shape speed override support via `SeasonalPreset.withOverrides(shapeSpeedMultipliers: ...)`.
- Add widget-level preset override params in `SeasonalDecor` for full runtime control:
  `presetShapes`, `presetStyles`, `presetShapeSpeedMultipliers`, `presetBackdrop`,
  `presetBackdrops`, `presetBackdropType`, `presetBackdropAnchor`,
  `presetBackdropSizeFactor`, `presetBackdropColor`, `presetBackdropOpacity`,
  `presetEnableFireworks`.

## 1.1.3

- Add simple example entrypoint and keep advanced demo in `advanced_main.dart`.

## 1.1.2

- Add preset overrides for shapes and backdrops via `withOverrides(...)`.
- Add `SeasonalPreset.none()` for no-decoration rendering.
- Add new particle shapes: lantern, balloon, sheep, gift, ornament.
- Add new backdrops: bunting, mosque, candy garland.
- Enhance Ramadan (lanterns) and Eid (Fitr/Adha variants with mosque + sheep).
- Improve Christmas visuals: detailed tree, candy garland, ornaments, gift drops.
- Update example app controls (preset overrides, backdrop positioning).
- Refresh GIF previews and add None preset screenshot.

## 1.0.1

- Update README previews to use GitHub raw links.

## 1.0.0

- Stable release of seasonal_decor.
- Presets: Ramadan, Eid, Christmas, New Year, Valentine, Halloween, Sport Event.
- Fireworks and sparkle variations with pooled particle system.
- Timed play cycles with settle mode and optional repeat cadence.
- Backdrop visibility controls (show/hide, keep on disable).
- Reduce motion handling and lifecycle pause support.
- Example app, GIF previews, and unit tests.

## 0.1.0

- Initial release.
