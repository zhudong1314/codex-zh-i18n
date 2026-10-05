# codex-zh-i18n 安装脚本（Codex++ 用户脚本）
# 用法：双击同目录 install.bat，或 powershell -File install.ps1
# 预览不改动：先运行 set DRYRUN=1 再运行 install.bat，或  powershell -File install.ps1 -DryRun
#   -SkipCodexpp    跳过"未检测到 Codex++ 时自动下载安装"步骤
#   -ForceSetup     强制走下载步骤（用于测试）
param([switch]$DryRun, [switch]$SkipCodexpp, [switch]$ForceSetup)
$ErrorActionPreference = "Stop"
$scriptPath  = Join-Path $PSScriptRoot "codex-zh-i18n.js"
$targetDir   = Join-Path $env:APPDATA "Codex++\user_scripts"
$target      = Join-Path $targetDir "codex-zh-i18n.js"
$dryRun      = $true -eq $DryRun -or $env:DRYRUN -eq "1"
$releaseUrl  = "https://api.github.com/repos/BigPizzaV3/CodexPlusPlus/releases/latest"
# ===== Codex++ 下载源（按优先级）=====
# 1) 本仓库镜像（codexplusplus/ 目录）：已由仓库所有者 zhudong1314 填写并启用；
#    镜像不可用时自动跳过，使用 2) 官方源。
$mirrorSetupUrl = "https://raw.githubusercontent.com/zhudong1314/codex-zh-i18n/main/codexplusplus/CodexPlusPlus-1.5.0-windows-x64-setup.exe"
$mirrorSha256   = "5F81231B1476AC6D3261541D78856C9B3574504C4240AE8376615694520D14B0"

function Test-CodexPlusPlusInstalled {
    $candidates = @(
        (Join-Path $env:APPDATA "Codex++"),
        (Join-Path $env:LOCALAPPDATA "Codex++"),
        (Join-Path $env:LOCALAPPDATA "CodexPlusPlus"),
        (Join-Path $env:LOCALAPPDATA "Programs\CodexPlusPlus"),
        "C:\Program Files\CodexPlusPlus",
        "C:\Program Files (x86)\CodexPlusPlus"
    )
    foreach ($c in $candidates) {
        if (Test-Path $c) {
            $exes = Get-ChildItem -Path $c -Recurse -Filter "codex-plus-plus*.exe" -ErrorAction SilentlyContinue | Select-Object -First 1
            if ($exes) { return "已找到 Codex++：$($exes.FullName)" }
        }
        if ($c -eq (Join-Path $env:APPDATA "Codex++") -or $c -eq (Join-Path $env:LOCALAPPDATA "Codex++")) {
            if (Test-Path $c) { return "已找到 Codex++ 数据目录：$c（若 Codex++ 装在自定义位置，请自行确认）" }
        }
    }
    return $null
}

function Get-LatestSetupUrl {
    $rel = Invoke-RestMethod -Uri $releaseUrl -Headers @{"Accept"="application/vnd.github+json"} -TimeoutSec 60
    $asset = $rel.assets | Where-Object { $_.name -match "windows-x64-setup\.exe$" } | Select-Object -First 1
    if (-not $asset) { throw "最新版本 $($rel.tag_name) 未找到 windows-x64-setup.exe 资源" }
    return [pscustomobject]@{Tag=$rel.tag_name; Url=$asset.browser_download_url; Name=$asset.name}
}

function Get-DownloadPlans {
    $plans = @()
    if ($mirrorSetupUrl -and $mirrorSetupUrl -notmatch "<YOUR_USERNAME>") {
        $plans += [pscustomobject]@{Tag="v1.5.0 (本仓库镜像)"; Url=$mirrorSetupUrl; FileName="CodexPlusPlus-1.5.0-windows-x64-setup.exe"; Sha256=$mirrorSha256; Source="本仓库 codexplusplus/ 镜像"}
    }
    try {
        $info = Get-LatestSetupUrl
        $sha = $(if ($info.Tag -eq "v1.5.0") { $mirrorSha256 } else { $null })
        $plans += [pscustomobject]@{Tag=$info.Tag; Url=$info.Url; FileName=$info.Name; Sha256=$sha; Source="BigPizzaV3 官方"}
    } catch {
        Write-Host "[提示] 无法获取官方最新 Release：$($_.Exception.Message)"
    }
    return $plans
}

if (-not (Test-Path $scriptPath)) {
    Write-Host "[错误] 未找到 $($scriptPath)；请使用解压后的完整安装包目录运行。"
    Read-Host "按回车退出" | Out-Null
    exit 1
}

# ---- Codex++ 检测 / 自动下载 ----
$detected = $null
$setupLaunched = $false
if (-not $SkipCodexpp) { $detected = Test-CodexPlusPlusInstalled }
$needSetup = (-not $detected) -or $ForceSetup

if ($needSetup) {
    Write-Host "[检测] 未检测到已安装的 Codex++。"
    $plans = Get-DownloadPlans
    if ($dryRun) {
        if ($plans.Count -eq 0) {
            Write-Host "[DRYRUN] 无可用自动下载源（镜像未填写且官方 Release 不可达）。"
        } else {
            Write-Host "[DRYRUN] 预览模式：Codex++ 未检测到，将按顺序尝试以下来源（不实际执行）："
            $plans | ForEach-Object { Write-Host "  $($_.Source) $($_.Tag): $($_.Url)" }
        }
    }
    elseif ([Console]::IsInputRedirected) {
        if ($plans.Count -eq 0) {
            Write-Host "[提示] 无可用自动下载源。请手动安装：https://github.com/BigPizzaV3/CodexPlusPlus/releases"
        } else {
            Write-Host "[提示] 当前为非交互模式，无法自动运行安装器。请手动下载："
            $plans | ForEach-Object { Write-Host "  $($_.Url)" }
        }
        Write-Host "       安装 Codex++ 后重新运行本脚本完成用户脚本安装。"
        exit 2
    }
    else {
        if ($plans.Count -eq 0) {
            Write-Host "[提示] 无可用自动下载源。请手动安装：https://github.com/BigPizzaV3/CodexPlusPlus/releases"
            Read-Host "按回车退出" | Out-Null
            exit 2
        }
        $answer = Read-Host "是否自动下载并安装 Codex++？（优先使用本仓库镜像，其次 BigPizzaV3 官方）[Y/n]"
        if ($answer -match "^[nN]") {
            Write-Host "[跳过] 已跳过自动下载。用户脚本仍会安装；请之后自行安装 Codex++（https://github.com/BigPizzaV3/CodexPlusPlus/releases）。"
        } else {
            foreach ($plan in $plans) {
                $exePath = Join-Path $env:TEMP $plan.FileName
                Write-Host "[下载] $($plan.Source) $($plan.Tag) → $exePath"
                try {
                    Invoke-WebRequest -Uri $plan.Url -OutFile $exePath -UseBasicParsing -TimeoutSec 900
                } catch {
                    Write-Host "[提示] 从 $($plan.Source) 下载失败：$($_.Exception.Message)"
                    continue
                }
                $size = (Get-Item $exePath).Length
                if ($size -lt 500KB) {
                    Remove-Item $exePath -Force -ErrorAction SilentlyContinue
                    Write-Host "[提示] 文件过小（$size 字节），疑似失败。"
                    continue
                }
                if ($plan.Sha256) {
                    $h = (Get-FileHash $exePath -Algorithm SHA256).Hash
                    if ($h -ne $plan.Sha256) {
                        Remove-Item $exePath -Force
                        Write-Host "[错误] SHA-256 校验不符，弃用该来源。"
                        continue
                    }
                    Write-Host "[校验] SHA-256 一致: $($h.Substring(0,16))..."
                } else {
                    Write-Host "[提示] 该来源（官方最新版）未钉扎 SHA-256，介意请自行核对该文件。"
                }
                Write-Host "[下载] 完成（$([math]::Round($size / 1MB, 1)) MB），即将启动 Codex++ 安装器。"
                Write-Host "       请在弹出的安装窗口中完成 Codex++ 安装，然后继续下面的步骤。"
                Start-Process -FilePath $exePath
                $setupLaunched = $true
                break
            }
            if (-not $setupLaunched) {
                Write-Host "[错误] 所有来源下载/校验均失败。请手动安装："
                $plans | ForEach-Object { Write-Host "  $($_.Url)" }
                Read-Host "按回车退出" | Out-Null
                exit 2
            }
        }
    }
} else {
    Write-Host "[检测] $detected"
}

if ($dryRun) {
    Write-Host "[DRYRUN] 预览模式，不会修改任何文件："
    Write-Host "  目标目录（不存在则创建）: $targetDir"
    Write-Host "  复制: $scriptPath -> $target"
    if (Test-Path $target) { Write-Host "  现有目标将先备份为 $target.bak-<时间戳>" }
    Read-Host "按回车退出" | Out-Null
    exit 0
}

if (-not (Test-Path $targetDir)) { New-Item -ItemType Directory -Path $targetDir -Force | Out-Null }
if (-not (Test-Path $targetDir)) {
    Write-Host "[错误] 无法创建目录 $targetDir"
    Read-Host "按回车退出" | Out-Null
    exit 1
}

if (Test-Path $target) {
    $ts = Get-Date -Format "yyyyMMddHHmmss"
    Copy-Item $target "$target.bak-$ts"
    Write-Host "[备份] 已备份现有脚本: $target.bak-$ts"
}
Copy-Item $scriptPath $target -Force

$hs = (Get-FileHash $scriptPath -Algorithm SHA256).Hash
$hd = (Get-FileHash $target -Algorithm SHA256).Hash
if ($hs -ne $hd) {
    Remove-Item $target -Force
    Write-Host "[错误] SHA-256 校验失败，已回滚本次安装。"
    Read-Host "按回车退出" | Out-Null
    exit 1
}
Write-Host "[校验] SHA-256 一致: $($hd.Substring(0,16))..."
Write-Host ""
Write-Host "================= 安装完成 ================="
if ($setupLaunched) {
    Write-Host "0. 请等 Codex++ 安装器完成安装（已为你启动下载与安装）。"
}
Write-Host "1. 用 Codex++ 启动（或重启）Codex 桌面端，脚本会随每次启动自动注入。"
Write-Host '2. 建议关闭 Codex++ 自带的"强制中文"开关，避免报错：'
Write-Host '   在你的 Codex++ 配置 settings.json 中把 "codexAppForceChineseLocale" 改为 false。'
Write-Host "3. 验证：界面文案变中文；CDP（默认 9229 端口）中"
Write-Host "   globalThis.__codexZhI18nState.patchedClients > 0 表示 i18n 开关已 patch。"
Write-Host "如需卸载：双击本目录下的 uninstall.bat。"
Read-Host "按回车退出" | Out-Null
