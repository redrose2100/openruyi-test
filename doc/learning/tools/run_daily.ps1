# -*- coding: utf-8 -*-
# run_daily.ps1 — 供 Windows 计划任务每日调用：同步上游 + 刷新文档 + 提交 + 推送 fork
# 用法: powershell -ExecutionPolicy Bypass -File doc\learning\tools\run_daily.ps1
$ErrorActionPreference = "Continue"
$Tools = Split-Path -Parent $MyInvocation.MyCommand.Path
$Repo  = Split-Path -Parent (Split-Path -Parent $Tools)
$Script = Join-Path $Tools "update_docs.sh"
$LogDir = Join-Path $Tools "logs"
New-Item -ItemType Directory -Force -Path $LogDir | Out-Null
$Log = Join-Path $LogDir ("daily_" + (Get-Date -Format "yyyyMMdd_HHmm") + ".log")

# 定位 git-bash
$bash = $null
foreach ($p in @("$env:ProgramFiles\Git\bin\bash.exe", "${env:ProgramFiles(x86)}\Git\bin\bash.exe", "$env:LOCALAPPDATA\Programs\Git\bin\bash.exe")) {
    if (Test-Path $p) { $bash = $p; break }
}
if (-not $bash) {
    $w = Get-Command bash.exe -ErrorAction SilentlyContinue
    if ($w) { $bash = $w.Source }
}
if (-not $bash) {
    "ERROR: 未找到 git-bash (bash.exe)，无法运行 update_docs.sh" | Tee-Object $Log
    exit 1
}

& $bash -l -c "cd '$Repo' && bash '$Script' --all" 2>&1 | Tee-Object -FilePath $Log
exit $LASTEXITCODE
