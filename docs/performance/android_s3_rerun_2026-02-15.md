# Android S3 Re-run (5 Runs)

- Date: 2026-02-15
- Scene: `S3 Football`
- Device: `PHW110 (emulator-5554, Android 9 API 28)`
- Mode: Profile
- Protocol: warmup 20s, capture 45s, between runs 15s

## Run Results

| Run | jank16 (>16.7ms) | jank33 (>33ms) | Raster p95 (ms) | Raster p99 (ms) | Worst frame (ms) |
| --- | --- | --- | --- | --- | --- |
| 1 | 6.437% | 0.996% | 17.967 | 32.772 | 67.487 |
| 2 | 0.736% | 0.147% | 12.970 | 15.749 | 44.705 |
| 3 | 18.142% | 1.032% | 23.565 | 32.211 | 68.815 |
| 4 | 1.549% | 0.147% | 14.070 | 18.164 | 45.243 |
| 5 | 1.549% | 0.000% | 14.366 | 17.635 | 30.708 |

## Median (5 Runs)

- `jank16`: **1.549%**
- `jank33`: **0.147%**
- `raster p95`: **14.366 ms**
- `raster p99`: **18.164 ms**
- `worst frame`: **45.243 ms**

## Decision

- Against Android thresholds, **median S3 passes**.
- Variance is high on emulator (2/5 runs exceeded `jank16 >= 3%`), so mark:
  **PASS عمليًا مع ملاحظة borderline على emulator**.
- Keep a follow-up confirmation on one physical mid-tier Android device.

## Artifacts

- `perf_artifacts/2026-02-15-s3-rerun/android/integration_response.json`

