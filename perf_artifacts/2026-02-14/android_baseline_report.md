# Performance Baseline Report

- Date: 2026-02-14
- Branch / commit: v/1.3.2 / e9bfc62
- App target: `example/lib/advanced_main.dart`
- Flutter version: 3.38.3
- Profiler: `integration_test.watchPerformance` (FrameTiming summary)

## Test Matrix

| Platform | Device | Renderer / OS |
| --- | --- | --- |
| Android | PHW110 (emulator-5554, Android 9 API 28) | Profile mode |
| Web | Not run in this pass | N/A |

## Summary (Median Of 3 Runs)

### Android

| Scene | UI avg | UI p95 | UI p99 | Raster avg | Raster p95 | Raster p99 | >16.7ms | >33ms | Pass/Fail |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| S0 | 0.33 | 0.69 | 1.07 | 2.34 | 4.19 | 9.20 | 0.16% | 0.00% | PASS |
| S1 | 1.25 | 2.86 | 5.91 | 7.33 | 13.63 | 23.67 | 2.42% | 0.23% | PASS |
| S2 | 1.10 | 2.14 | 3.75 | 6.75 | 10.37 | 15.68 | 0.84% | 0.15% | PASS |
| S3 | 1.62 | 2.91 | 4.35 | 11.63 | 15.11 | 19.37 | 3.01% | 0.08% | FAIL |
| S4 | 0.61 | 0.99 | 1.65 | 2.32 | 3.31 | 5.21 | 0.00% | 0.00% | PASS |
| S5 | 0.62 | 0.96 | 1.54 | 3.56 | 4.94 | 7.20 | 0.00% | 0.00% | PASS |
| S6 | 0.31 | 0.59 | 0.95 | 2.25 | 3.94 | 5.99 | 0.07% | 0.00% | PASS |

### Web

Not measured in this run.

## Delta vs S0 Baseline

| Platform | Scene | UI avg delta | Raster avg delta | p99 delta | Jank delta |
| --- | --- | --- | --- | --- | --- |
| Android | S1 | +0.92 ms | +5.00 ms | +14.48 ms | +2.26 pp |
| Android | S2 | +0.77 ms | +4.41 ms | +6.48 ms | +0.69 pp |
| Android | S3 | +1.29 ms | +9.29 ms | +10.18 ms | +2.85 pp |
| Android | S4 | +0.28 ms | -0.02 ms | -3.98 ms | -0.16 pp |
| Android | S5 | +0.29 ms | +1.22 ms | -1.99 ms | -0.16 pp |
| Android | S6 | -0.02 ms | -0.09 ms | -3.21 ms | -0.08 pp |

## Top Offenders

1. Scene S1
   - Timestamp window: N/A (FrameTiming summary only)
   - Thread: Raster
   - Symptom: run 2 worst frame 66.91ms
1. Scene S3
   - Timestamp window: N/A (FrameTiming summary only)
   - Thread: Raster
   - Symptom: run 1 worst frame 52.15ms
1. Scene S2
   - Timestamp window: N/A (FrameTiming summary only)
   - Thread: Raster
   - Symptom: run 1 worst frame 65.23ms

## Memory Notes

- Android: direct resident-memory trend is not included in `watchPerformance`; GC counters by scene: S0(new:10, old:0), S1(new:28, old:0), S2(new:54, old:0), S3(new:54, old:0), S4(new:38, old:0), S5(new:26, old:0), S6(new:10, old:0).
- Web: not measured.

## Recommendation Block (Actionable)

1. File/function: `lib/src/engine/decor_painter.dart`
   - Proposed optimization: simplify high-cost particle paint paths for max intensity scenes (S2/S4).
   - Expected impact: lower raster p95/p99 spikes.
2. File/function: `lib/src/widgets/seasonal_decor.dart`
   - Proposed optimization: add optional throttled ticker mode for text-heavy / backdrop-only scenarios.
   - Expected impact: lower UI jank in S5.
3. File/function: `lib/src/engine/particle_system.dart`
   - Proposed optimization: cap burst spawn per frame under sustained load.
   - Expected impact: smoother worst-frame behavior in stress scenes.

## Artifacts

- `perf_artifacts/2026-02-14/android/integration_response.json`
- `perf_artifacts/2026-02-14/android_baseline_report.md`
