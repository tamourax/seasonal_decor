# Perf Tooling

Manual-first helper scripts for device profiling.

## Start A Session

```powershell
powershell -ExecutionPolicy Bypass -File tool/perf/start_session.ps1 -Platform android
powershell -ExecutionPolicy Bypass -File tool/perf/start_session.ps1 -Platform web
```

Optional date override:

```powershell
powershell -ExecutionPolicy Bypass -File tool/perf/start_session.ps1 -Platform android -Date 2026-02-14
```

This creates:

1. `perf_artifacts/<date>/<platform>/`
2. `run_log.csv`
3. `<platform>_baseline_report.md` from `docs/performance/baseline_report_template.md`

## Next Step

Follow `docs/performance/device_profiling.md` for scene setup, capture protocol, and thresholds.

## Web Automation Note

`flutter drive` on web requires a WebDriver server (ChromeDriver) on port `4444`.

If you keep ChromeDriver at `tool/chromedriver/chromedriver-win64/chromedriver.exe`,
you can run:

```powershell
$driver = Start-Process -FilePath "tool/chromedriver/chromedriver-win64/chromedriver.exe" -ArgumentList "--port=4444" -PassThru
try {
  cd example
  $env:PERF_DATE='2026-02-15-web'
  $env:PERF_PLATFORM='web'
  flutter drive --no-dds --driver=test_driver/perf_driver.dart --target=integration_test/perf_scenes_test.dart -d chrome --profile --dart-define=PERF_PREFIX=web --dart-define=PERF_SCENE=S0 --dart-define=PERF_RUNS=3 --dart-define=PERF_WARMUP_SECONDS=20 --dart-define=PERF_CAPTURE_SECONDS=45 --dart-define=PERF_BETWEEN_SECONDS=15
} finally {
  Stop-Process -Id $driver.Id -Force
}
```
