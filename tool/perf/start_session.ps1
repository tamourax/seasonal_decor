param(
  [ValidateSet("android", "web")]
  [string]$Platform = "android",
  [string]$Date = (Get-Date -Format "yyyy-MM-dd")
)

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\\..")).Path
$artifactRoot = Join-Path $repoRoot "perf_artifacts"
$sessionRoot = Join-Path $artifactRoot $Date
$platformRoot = Join-Path $sessionRoot $Platform

New-Item -ItemType Directory -Force -Path $artifactRoot | Out-Null
New-Item -ItemType Directory -Force -Path $sessionRoot | Out-Null
New-Item -ItemType Directory -Force -Path $platformRoot | Out-Null

$runLogPath = Join-Path $platformRoot "run_log.csv"
if (!(Test-Path $runLogPath)) {
  "timestamp,scene,run,file,notes" | Set-Content -Path $runLogPath -Encoding UTF8
}

$templatePath = Join-Path $repoRoot "docs\\performance\\baseline_report_template.md"
$reportPath = Join-Path $sessionRoot "${Platform}_baseline_report.md"
if ((Test-Path $templatePath) -and !(Test-Path $reportPath)) {
  Copy-Item -Path $templatePath -Destination $reportPath
}

Write-Host "Session prepared."
Write-Host "Artifacts folder: $platformRoot"
Write-Host "Run log: $runLogPath"
if (Test-Path $reportPath) {
  Write-Host "Report template: $reportPath"
}

