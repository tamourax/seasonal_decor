# Device Profiling Plan (Android + Web)

This runbook profiles `seasonal_decor` with `example/lib/advanced_main.dart`.
It is manual-first and reproducible.

## Locked Decisions

1. Device matrix: mid-tier Android + desktop Chrome.
2. Threshold policy: balanced 60fps.
3. Execution mode: manual script first, automation later.

## Scope

1. Profile heavy presets, text animation, backdrop-only mode, and fireworks.
2. Measure UI/raster frame timing, jank ratio, and memory stability.
3. Produce artifacts and a baseline report that can be reused for regression checks.

## Out Of Scope

1. CI hard-fail enforcement in this iteration.
2. Low-end Android gating.
3. Public package API changes.

## Build Commands

Android profile:

```bash
flutter run -t example/lib/advanced_main.dart --profile -d <android_device_id>
```

Web profile (CanvasKit):

```bash
flutter run -t example/lib/advanced_main.dart -d chrome --profile --web-renderer canvaskit
```

Use Flutter DevTools Performance page to capture and export timeline JSON.

## Environment Checklist

1. Keep device connected and battery saver disabled.
2. Close background downloads/apps.
3. Keep thermal state stable before long captures.
4. Run only in profile mode.

## Scene Matrix (S0..S6)

Use the `Profiling Scene` chips in `advanced_main.dart` to apply scenes exactly.

| Scene ID | Preset / Mode | Required Controls |
| --- | --- | --- |
| S0 | Baseline idle | `Preset: None`, `enabled: true`, `showBackdrop: false`, `showText: false`, `intensity: medium` |
| S1 | Ramadan classic heavy decorative | `Preset: Ramadan`, `intensity: max`, `showBackdrop: true`, `showDecorativeBackdrops: true`, `decorativeBackdropRows: 6`, `showText: false` |
| S2 | Ramadan lights stress | `Preset: Ramadan Lights`, `intensity: max`, `showBackdrop: true`, `decorativeBackdropRows: 4`, `particleSpeedMultiplier: 2.0`, `particleSizeMultiplier: 2.0`, `showText: false` |
| S3 | Football particles stress | `Preset: Football`, `intensity: max`, `showBackdrop: true`, `showText: false`, `particleSpeedMultiplier: 2.0`, `particleSizeMultiplier: 2.0` |
| S4 | New Year fireworks stress | `Preset: New Year`, `intensity: max`, `presetEnableFireworks: true`, `showBackdrop: true`, `showText: false` |
| S5 | Text animation stress | `Preset: Ramadan`, `showText: true`, `text: long custom string`, `textSize: 56`, `textOpacity: 1.0`, `textAnimationDuration: 1200ms`, `textDisplayDuration: 4s`, `textAlignX: 0`, `textAlignY: -1`, `textTopPadding: 56` |
| S6 | Backdrop-only performance mode | `Preset: Ramadan`, `enabled: false`, `showBackdrop: true`, `showBackdropWhenDisabled: true`, `presetShapes: []` |

## Capture Protocol (Per Scene)

1. Launch profile build and apply scene.
2. Warm up for 20 seconds (discard).
3. Capture a 45-second timeline in DevTools.
4. Repeat 3 runs per scene per platform.
5. Save each run:
   `perf_artifacts/<date>/<platform>/<scene_id>_run<N>.json`
6. Wait 15 seconds between runs on the same scene.
7. On Android, repeat full suite once after full app restart.

## Metrics To Record

1. UI frame time: avg / p95 / p99.
2. Raster frame time: avg / p95 / p99.
3. Jank ratio:
   - `% frames > 16.7ms`
   - `% frames > 33ms`
4. Slow frame count and worst frame spike.
5. Memory trend over 45 seconds (growth + GC spikes).
6. Visual hitch notes (text transition, burst spikes, preset switch behavior).

## Pass / Fail Thresholds

### Android (mid-tier)

1. UI avg <= 16.7ms
2. Raster avg <= 16.7ms
3. UI/Raster p95 <= 24ms
4. UI/Raster p99 <= 33ms
5. Frames > 16.7ms < 3%
6. Frames > 33ms < 0.5%

### Web (Chrome + CanvasKit)

1. UI avg <= 18ms
2. Raster avg <= 18ms
3. UI/Raster p95 <= 28ms
4. UI/Raster p99 <= 40ms
5. Frames > 16.7ms < 5%
6. Frames > 33ms < 1%

### Scene Gate Rules

1. Critical scenes: S2, S4, S5.
2. S0 must stay comfortably below thresholds.
3. Any critical-scene fail blocks perf sign-off.

## Reporting

1. One summary table per platform using median of 3 runs.
2. One delta table vs S0.
3. One top-offenders list (highest p99 windows + timestamps).
4. One recommendation block mapped to files/functions.

Use: `docs/performance/baseline_report_template.md`

## Failure Handling

1. If only 1/3 fails, run once more and use median of best 3/4.
2. If repeat failures happen in same scene, mark reproducible and open optimization task.
3. If thermal throttling is suspected, cool down 5 minutes and rerun.

## Phases

1. Phase A: manual profiling and baseline report.
2. Phase B: optimize only failed scenes and rerun them.
3. Phase C: automate via `integration_test` + parser.
4. Phase D: promote from CI warning to hard fail after two stable releases.
