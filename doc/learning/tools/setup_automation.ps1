# setup_automation.ps1 - one-time setup for doc/learning auto-refresh
#  1. add upstream remote (https://gitcode.com/openeuler/mugen.git) if missing
#  2. enable git hooksPath = doc/learning/tools/hooks (pre-push hook becomes active)
#  3. optional: create a Windows scheduled task that syncs upstream + refreshes
#     docs + pushes the fork every day
# Usage:
#   powershell -ExecutionPolicy Bypass -File doc\learning\tools\setup_automation.ps1
#   # skip scheduled task:
#   powershell -ExecutionPolicy Bypass -File doc\learning\tools\setup_automation.ps1 -SkipScheduledTask
# Note: this file is ASCII-only (PowerShell 5.1 mis-reads non-BOM UTF-8 as ANSI).
# See doc/learning/tools/README.md for the Chinese documentation.
param(
    [string]$ForkUrl = "",
    [string]$UpstreamUrl = "https://gitcode.com/openeuler/mugen.git",
    [string]$DailyTime = "08:00",
    [switch]$SkipScheduledTask
)
$ErrorActionPreference = "Stop"

$Tools = Split-Path -Parent $MyInvocation.MyCommand.Path
$Repo  = Split-Path -Parent (Split-Path -Parent $Tools)
Set-Location $Repo

Write-Host "=== doc/learning auto-refresh setup ==="

# 1. upstream remote
$hasUpstream = git remote get-url upstream 2>$null
if (-not $hasUpstream) {
    git remote add upstream $UpstreamUrl
    Write-Host "[OK] added upstream = $UpstreamUrl"
} else {
    Write-Host "[SKIP] upstream already set = $hasUpstream"
}

# 2. hooksPath (pre-push hook on master)
git config core.hooksPath doc/learning/tools/hooks
Write-Host "[OK] core.hooksPath = doc/learning/tools/hooks (push master -> sync upstream + refresh docs)"
if (-not (Test-Path "$Repo\.git\hooks\pre-push")) {
    if (Test-Path "$Repo\.git") {
        Copy-Item "$Tools\hooks\pre-push" "$Repo\.git\hooks\pre-push" -Force
        Write-Host "[OK] also copied pre-push to .git/hooks/"
    }
}

# 3. daily scheduled task (sync upstream + refresh + push fork)
if (-not $SkipScheduledTask) {
    $runDaily = Join-Path $Tools "run_daily.ps1"
    $taskName = "mugen-docs-refresh"
    if (Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue) {
        Write-Host "[SKIP] task $taskName already exists (remove: Unregister-ScheduledTask -TaskName $taskName)"
    } else {
        $arg = "-NoProfile -ExecutionPolicy Bypass -File `"$runDaily`""
        $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument $arg
        $trigger = New-ScheduledTaskTrigger -Daily -At $DailyTime
        Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Description "mugen doc/learning daily refresh" -Force | Out-Null
        Write-Host "[OK] scheduled task $taskName created (daily $DailyTime -> $runDaily)"
        Write-Host "     run now: Start-ScheduledTask -TaskName $taskName"
    }
} else {
    Write-Host "[SKIP] no scheduled task (-SkipScheduledTask)"
}

Write-Host ""
Write-Host "=== done ==="
Write-Host "manual one-shot:  bash doc/learning/tools/update_docs.sh --all"
Write-Host "local refresh:    bash doc/learning/tools/update_docs.sh --regen-only"
