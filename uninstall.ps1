# codex-zh-i18n 卸载脚本（Codex++ 用户脚本）
# 用法：双击同目录 uninstall.bat，或 powershell -File uninstall.ps1
# 预览不改动：先运行 set DRYRUN=1 再运行 uninstall.bat，或  powershell -File uninstall.ps1 -DryRun
param([switch]$DryRun)
$ErrorActionPreference = "Stop"
$targetDir = Join-Path $env:APPDATA "Codex++\user_scripts"
$target    = Join-Path $targetDir "codex-zh-i18n.js"
$dryRun    = $true -eq $DryRun -or $env:DRYRUN -eq "1"

if ($dryRun) {
    Write-Host "[DRYRUN] 预览模式，不会修改任何文件："
    if (Test-Path $target) { Write-Host "  将删除: $target" }
    else { Write-Host "  无用户脚本可删除: $target" }
    Read-Host "按回车退出" | Out-Null
    exit 0
}

if (-not (Test-Path $target)) {
    Write-Host "[提示] 未找到用户脚本: $target"
    Write-Host "       无需卸载（或未安装过）。"
    Read-Host "按回车退出" | Out-Null
    exit 0
}
Remove-Item $target -Force
Write-Host "[卸载] 已删除用户脚本: $target"
$baks = Get-ChildItem -Path $targetDir -Filter "codex-zh-i18n.js.bak-*" -ErrorAction SilentlyContinue
if ($baks) {
    Write-Host ""
    Write-Host "备份 .bak-* 文件（$($baks.Count) 个）仍保留在 $targetDir ："
    $baks | ForEach-Object { Write-Host "  $($_.Name)" }
}
Write-Host "如需恢复：重新运行 install.bat，或把备份复制回 codex-zh-i18n.js。"
Write-Host '同时可把 Codex++ 自带"强制中文"开关改回 true（settings.json 的 codexAppForceChineseLocale）。'
Read-Host "按回车退出" | Out-Null
