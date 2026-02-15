# Performance Baseline Report

- Date:
- Branch / commit:
- App target: `example/lib/advanced_main.dart`
- Flutter version:
- Profiler: Flutter DevTools timeline export

## Test Matrix

| Platform | Device | Renderer / OS |
| --- | --- | --- |
| Android |  | Profile mode |
| Web |  | Chrome + CanvasKit |

## Summary (Median Of 3 Runs)

### Android

| Scene | UI avg | UI p95 | UI p99 | Raster avg | Raster p95 | Raster p99 | >16.7ms | >33ms | Pass/Fail |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| S0 |  |  |  |  |  |  |  |  |  |
| S1 |  |  |  |  |  |  |  |  |  |
| S2 |  |  |  |  |  |  |  |  |  |
| S3 |  |  |  |  |  |  |  |  |  |
| S4 |  |  |  |  |  |  |  |  |  |
| S5 |  |  |  |  |  |  |  |  |  |
| S6 |  |  |  |  |  |  |  |  |  |

### Web

| Scene | UI avg | UI p95 | UI p99 | Raster avg | Raster p95 | Raster p99 | >16.7ms | >33ms | Pass/Fail |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| S0 |  |  |  |  |  |  |  |  |  |
| S1 |  |  |  |  |  |  |  |  |  |
| S2 |  |  |  |  |  |  |  |  |  |
| S3 |  |  |  |  |  |  |  |  |  |
| S4 |  |  |  |  |  |  |  |  |  |
| S5 |  |  |  |  |  |  |  |  |  |
| S6 |  |  |  |  |  |  |  |  |  |

## Delta vs S0 Baseline

| Platform | Scene | UI avg delta | Raster avg delta | p99 delta | Jank delta |
| --- | --- | --- | --- | --- | --- |
| Android | S1 |  |  |  |  |
| Android | S2 |  |  |  |  |
| Android | S3 |  |  |  |  |
| Android | S4 |  |  |  |  |
| Android | S5 |  |  |  |  |
| Android | S6 |  |  |  |  |
| Web | S1 |  |  |  |  |
| Web | S2 |  |  |  |  |
| Web | S3 |  |  |  |  |
| Web | S4 |  |  |  |  |
| Web | S5 |  |  |  |  |
| Web | S6 |  |  |  |  |

## Top Offenders

1. Scene:
   - Timestamp window:
   - Thread:
   - Symptom:
2. Scene:
   - Timestamp window:
   - Thread:
   - Symptom:
3. Scene:
   - Timestamp window:
   - Thread:
   - Symptom:

## Memory Notes

- Android:
- Web:

## Recommendation Block (Actionable)

1. File/function:
   - Proposed optimization:
   - Expected impact:
2. File/function:
   - Proposed optimization:
   - Expected impact:
3. File/function:
   - Proposed optimization:
   - Expected impact:

## Artifacts

- `perf_artifacts/<date>/android/*.json`
- `perf_artifacts/<date>/web/*.json`
- Any screenshots:

