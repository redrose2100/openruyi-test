# run_daily.ps1 - daily scheduled task entry: sync upstream + refresh docs + commit + push fork
# Usage: powershell -ExecutionPolicy Bypass -File doc\learning\tools\run_daily.ps1
# Note: this file is ASCII-only (PowerShell 5.1 mis-reads non-BOM UTF-8 as ANSI).
$ErrorActionPreference = "Continue"
$Tools = Split-Path -Parent $MyInvocation.MyCommand.Path
$Repo  = Split-Path -Parent (Split-Path -Parent $Tools)
$Script = Join-Path $Tools "update_docs.sh"
$LogDir = Join-Path $Tools "logs"
New-Item -ItemType Directory -Force -Path $LogDir | Out-Null
$Log = Join-Path $LogDir ("daily_" + (Get-Date -Format "yyyyMMdd_HHmm") + ".log")

# locate git-bash
$bash = $null
foreach ($p in @("$env:ProgramFiles\Git\bin\bash.exe", "${env:ProgramFiles(x86)}\Git\bin\bash.exe", "$env:LOCALAPPDATA\Programs\Git\bin\bash.exe")) {
    if (Test-Path $p) { $bash = $p; break }
}
if (-not $bash) {
    $w = Get-Command bash.exe -ErrorAction SilentlyContinue
    if ($w) { $bash = $w.Source }
}
if (-not $bash) {
    "ERROR: git-bash (bash.exe) not found - cannot run update_docs.sh" | Tee-Object $Log
    exit 1
}

& $bash -l -c "cd '$Repo' && bash '$Script' --all" 2>&1 | Tee-Object -FilePath $Log
exit $LASTEXITCODE
