# Performance Baseline Report (Web)

- Date: 2026-02-15-web
- Branch / commit: v/1.3.2 / e9bfc62
- App target: `example/lib/advanced_main.dart`
- Flutter version: 3.38.3
- Profiler: `integration_test.watchPerformance` (FrameTiming summary)

## Test Matrix

| Platform | Device | Renderer / OS |
| --- | --- | --- |
| Android | Not run in this pass | N/A |
| Web | Chrome 144 (profile) | Chrome + CanvasKit (profile) |

## Summary (Median Of 3 Runs, with S3 re-run as Median Of 5 Runs)

### Web

| Scene | UI avg | UI p95 | UI p99 | Raster avg | Raster p95 | Raster p99 | >16.7ms | >33ms | Pass/Fail |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| S0 | 1.12 | 1.90 | 2.60 | 0.85 | 1.50 | 2.00 | 0.00% | 0.00% | PASS |
| S1 | 8.20 | 12.30 | 13.80 | 0.92 | 1.40 | 1.80 | 0.13% | 0.00% | PASS |
| S2 | 7.26 | 10.30 | 11.30 | 0.77 | 1.20 | 1.50 | 0.00% | 0.00% | PASS |
| S3 | 11.00 | 15.40 | 16.90 | 0.69 | 1.10 | 1.60 | 1.42% | 0.00% | PASS* |
| S4 | 2.73 | 4.20 | 5.20 | 0.68 | 1.10 | 2.00 | 0.00% | 0.00% | PASS |
| S5 | 3.01 | 4.70 | 5.30 | 0.74 | 1.20 | 1.60 | 0.00% | 0.00% | PASS |
| S6 | 0.94 | 1.60 | 2.40 | 0.68 | 1.10 | 1.60 | 0.00% | 0.00% | PASS |

## Delta vs S0 Baseline

| Platform | Scene | UI avg delta | Raster avg delta | p99 delta | Jank delta |
| --- | --- | --- | --- | --- | --- |
| Web | S1 | +7.08 ms | +0.07 ms | +11.20 ms | +0.13 pp |
| Web | S2 | +6.15 ms | -0.07 ms | +8.70 ms | +0.00 pp |
| Web | S3 | +9.88 ms | -0.16 ms | +14.30 ms | +1.42 pp |
| Web | S4 | +1.61 ms | -0.16 ms | +2.60 ms | +0.00 pp |
| Web | S5 | +1.90 ms | -0.10 ms | +2.70 ms | +0.00 pp |
| Web | S6 | -0.18 ms | -0.16 ms | -0.20 ms | +0.00 pp |

## Top Offenders

1. Scene S3
   - Timestamp window: N/A (FrameTiming summary only)
   - Thread: UI
   - Symptom: re-run (5 runs) still shows spikes, worst frame 25.40ms
1. Scene S1
   - Timestamp window: N/A (FrameTiming summary only)
   - Thread: UI
   - Symptom: run 3 worst frame 17.00ms
1. Scene S2
   - Timestamp window: N/A (FrameTiming summary only)
   - Thread: UI
   - Symptom: run 1 worst frame 15.30ms

## Notes

- Web thresholds used: avg<=18ms, p95<=28ms, p99<=40ms, >16.7ms<5%, >33ms<1%.
- Critical scenes for gate rules: S2, S4, S5.
- `*` S3 uses dedicated 5-run re-test median.
  High variance on browser/emulator stack; confirm once on another machine.

## Artifacts

- `perf_artifacts/2026-02-15-web/web/integration_response.json`
- `perf_artifacts/2026-02-15-web/web_baseline_report.md`
- `perf_artifacts/2026-02-15-web-s3-rerun/web/integration_response.json`
- `docs/performance/web_s3_rerun_2026-02-15.md`
