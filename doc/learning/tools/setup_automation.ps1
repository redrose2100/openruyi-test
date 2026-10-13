# setup_automation.ps1 — 一次性配置 doc/learning 自动刷新机制
# 功能:
#   1. 添加上游远端 upstream (gitcode.com/openeuler/mugen，如未配置)
#   2. 启用 git hooksPath = doc/learning/tools/hooks（pre-push 钩子自动生效）
#   3. 可选: 创建 Windows 计划任务每日自动同步+刷新+推送
# 用法:
#   powershell -ExecutionPolicy Bypass -File doc\learning\tools\setup_automation.ps1
#   # 仅配置远端与钩子，不建计划任务:
#   powershell ... -SkipScheduledTask
# 参数:
#   -ForkUrl     个人 fork 远端 URL（默认不修改 origin）
#   -UpstreamUrl 源项目 URL（默认 https://gitcode.com/openeuler/mugen.git）
#   -DailyTime    计划任务运行时间 HH:mm（默认 08:00）
$ErrorActionPreference = "Stop"
param(
    [string]$ForkUrl = "",
    [string]$UpstreamUrl = "https://gitcode.com/openeuler/mugen.git",
    [string]$DailyTime = "08:00",
    [switch]$SkipScheduledTask
)

$Tools = Split-Path -Parent $MyInvocation.MyCommand.Path
$Repo  = Split-Path -Parent (Split-Path -Parent $Tools)
Set-Location $Repo

Write-Host "=== doc/learning 自动刷新配置 ==="

# 1. upstream 远端
$hasUpstream = git remote get-url upstream 2>$null
if (-not $hasUpstream) {
    git remote add upstream $UpstreamUrl
    Write-Host "[OK] 已添加 upstream = $UpstreamUrl"
} else {
    Write-Host "[SKIP] upstream 已存在 = $hasUpstream"
}

# 2. hooksPath
git config core.hooksPath doc/learning/tools/hooks
Write-Host "[OK] core.hooksPath = doc/learning/tools/hooks（pre-push 钩子生效，推送 master 时自动同步+刷新）"
if (-not (Test-Path "$Repo\.git\hooks\pre-push")) {
    # 兼容无 core.hooksPath 的旧工具链: 同时复制一份到 .git/hooks
    if (Test-Path "$Repo\.git") {
        Copy-Item "$Tools\hooks\pre-push" "$Repo\.git\hooks\pre-push" -Force
        Write-Host "[OK] 已复制 pre-push 到 .git/hooks/"
    }
}

# 3. 计划任务（每日同步上游 + 刷新 + 推送 fork）
if (-not $SkipScheduledTask) {
    $runDaily = Join-Path $Tools "run_daily.ps1"
    $cmd = "powershell.exe -NoProfile -ExecutionPolicy Bypass -File `"$runDaily`""
    $taskName = "mugen-docs-refresh"
    if (Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue) {
        Write-Host "[SKIP] 计划任务 $taskName 已存在（可运行: Unregister-ScheduledTask -TaskName $taskName 后重配）"
    } else {
        $action = New-ScheduledTaskAction -Execute "powershell.exe" `
            -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$runDaily`""
        $trigger = New-ScheduledTaskTrigger -Daily -At $DailyTime
        Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger `
            -Description "mugen doc/learning 每日同步上游并刷新学习文档" -Force | Out-Null
        Write-Host "[OK] 计划任务 $taskName 已创建（每日 $DailyTime 运行 $runDaily）"
        Write-Host "     手动立即运行: Start-ScheduledTask -TaskName $taskName"
    }
} else {
    Write-Host "[SKIP] 未创建计划任务（-SkipScheduledTask）"
}

Write-Host ""
Write-Host "=== 完成 ==="
Write-Host "手动刷新一次:  bash doc/learning/tools/update_docs.sh --all"
Write-Host "仅本地刷新:    bash doc/learning/tools/update_docs.sh --regen-only"
