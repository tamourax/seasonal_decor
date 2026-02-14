## 1.2.0

- Add scene-based atmosphere system with three visual layers:
  animated backdrop, ambient parallax particles, and triggerable moments.
- Add new public APIs:
  `SeasonalMode`, `SeasonalMoment`, `SeasonalMomentOptions`,
  and `SeasonalDecorController`.
- Add moment triggers via controller (`controller.trigger(...)`) with
  reduce-motion safe remapping.
- Add theme-harmonized palette generation driven by app primary color and mode.
- Update `SeasonalDecor` to support calm reduce-motion behavior
  (slower + fewer particles instead of full disable).
- Refresh advanced demo with experience controls:
  preset dropdown, mode selector, intensity slider, reduce-motion toggle,
  and moment trigger buttons.
- Add Flutter web loading splash in `example/web/index.html` to avoid blank load.

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
