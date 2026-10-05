# codex-zh-i18n（Codex++ 用户脚本·一键安装包）

让 Codex 桌面端界面强制显示 **中文 (zh-CN)**，同时保留 BigPizzaV3/CodexPlusPlus（Codex++）的模型中转/路由功能——一个工具同时搞定 中文界面 + 选模型，不用再装单独的汉化工具。

派生自 MIT 许可的 [codex-desktop-zh](https://github.com/shibaweidu/codex-desktop-zh) 项目（核心即其 `shared/i18n-bootstrap.js`，逐字保留、仅加许可头与幂等守卫），见 [LICENSE](LICENSE)。

## 平台支持（先读这个）

| 平台 | 本包 | 安装方式 |
|---|---|---|
| **Windows x64** | ✅ 一键安装包 | 解压 → 双击 `install.bat`（自动检测/自动下载 Codex++ Windows 版） |
| **macOS**（Apple Silicon / Intel） | ⚠️ 无一键脚本（`install.bat`/`install.ps1`/`uninstall.bat` 均为 Windows 专用） | 手动：安装 Codex++ macOS 官方版（DMG）＋把 `codex-zh-i18n.js` 放入 `~/.config/Codex++/user_scripts/`，见下文「手动安装」 |
| **Linux** | ❌ 上游目前不发布 Codex++ Linux 版 | 自行构建 Codex++ 后，把脚本放入 `~/.config/Codex++/user_scripts/` |

`codex-zh-i18n.js` 本身是**平台无关**的（由 Codex++ 经 CDP 注入 Codex 页面的浏览器脚本）；只有一键安装/卸载层是 Windows 专用。

## 前提

本脚本**不是独立软件**，是 Codex++ 的用户脚本，依赖两个前提：

1. 已安装 **Codex 桌面端**（OpenAI）；
2. 已安装 **Codex++**（BigPizzaV3/CodexPlusPlus，AGPL-3.0）——注入和模型路由都由它驱动。**没装也没关系**：`install.bat` 会自动检测，检测不到时会征得你同意，**优先从本仓库的 `codexplusplus/` 镜像下载**（仓库所有者 `zhudong1314` 已在 `install.ps1` 填写启用），否则回落 **BigPizzaV3 官方 GitHub Releases**（自动跟最新 release）；你也可以选"否"或稍后手动安装。

上述自动检测/自动下载只适用于 Windows 一键流程；**macOS 用户请直接看「手动安装」**。

- **没装 Codex++ 且选择跳过下载**：用户脚本文件仍会放入目录，但 Codex++ 装上之前不会生效。
- **完全不想装 Codex++**：本脚本帮不了你（注入和路由都由 Codex++ 驱动），请直接用独立汉化包（上游 [codex-desktop-zh](https://github.com/shibaweidu/codex-desktop-zh) 或 xqnode/codex-zh-CN，均 MIT、自带安装器），但那样就只有中文、没有模型路由。
- **没装汉化包**：没问题，这正是本脚本要替代它的——装上 Codex++ + 本脚本即可，汉化包可卸载。

## 安装（一键安装包，仅 Windows，最简单）

1. 解压安装包 zip（或直接点本仓库右上角 **Code → Download ZIP**，下载下来的 zip 就是安装包）。
2. 双击 `install.bat`（**不需要管理员权限**，只写入 `%APPDATA%\Codex++\user_scripts\`）。
   - 脚本会先备份已存在的旧文件，复制后做 SHA-256 校验，失败自动回滚。
   - 若未检测到 Codex++，会征求你的同意后自动下载官方安装器（BigPizzaV3 官方 GitHub Releases）；选"否"则显示手动下载链接。
   - 想先看看不动手：`powershell -File install.ps1 -DryRun`（或在 cmd 里 `set DRYRUN=1` 后运行 `install.bat`）。
3. 用 **Codex++ 启动 Codex** 即完成安装：用户脚本被自动发现、默认启用，每次启动经 CDP 注入。

### 可选但推荐
在 Codex++ 的配置 `settings.json` 中把 `"codexAppForceChineseLocale"` 改为 `false`（关闭其自带、易报错的强制中文开关，与本脚本并存更干净）。不关也不影响本脚本工作。

## 手动安装（不用安装包时，或 macOS / Linux）

把 [`codex-zh-i18n.js`](codex-zh-i18n.js) 放进 Codex++ 的用户脚本目录（自动发现、默认启用；只加载 `.js` 文件，按文件名小写排序执行；目录权威出处见上游 [EXTENSIONS.md](https://github.com/BigPizzaV3/CodexPlusPlus/blob/main/EXTENSIONS.md)）：

### Windows

`%APPDATA%\Codex++\user_scripts\`

### macOS

1. 安装 Codex++ macOS 官方版（[BigPizzaV3/CodexPlusPlus Releases](https://github.com/BigPizzaV3/CodexPlusPlus/releases)，两个架构都有，按机器选）：
   - Apple Silicon（M1/M2/…）：`CodexPlusPlus-1.5.0-macos-arm64.dmg`
   - Intel：`CodexPlusPlus-1.5.0-macos-x64.dmg`
2. 把脚本放进用户脚本目录：

   ```bash
   mkdir -p "$HOME/.config/Codex++/user_scripts"
   cp codex-zh-i18n.js "$HOME/.config/Codex++/user_scripts/"
   ```
3. 用 Codex++ 启动 Codex。若目录里已有脚本且修改过，可在 Codex++ 管理页「拓展」页点「热重载拓展」，无需重启 Codex。

### Linux（无官方发布）

上游目前不发布 Codex++ Linux 版；自行构建后，把脚本放进 `~/.config/Codex++/user_scripts/`（同 macOS）。

**macOS / Linux 卸载**：删除 `~/.config/Codex++/user_scripts/codex-zh-i18n.js` 并重启 Codex 即可。

## 验证

启动后菜单、按钮等界面文案为中文。可用 CDP（默认 9229 端口）查询：
`globalThis.__codexZhI18nState` 的 `patchedClients > 0` 即表示 i18n 开关已被 patch。

## 卸载 / 回退

- **Windows**：双击 `uninstall.bat`（或手动删除 `codex-zh-i18n.js`）并重启 Codex；备份的 `.bak-*` 仍在原目录，可随时复制回原位恢复。需要时把 `codexAppForceChineseLocale` 改回 `true`。
- **macOS / Linux**：直接删除 `~/.config/Codex++/user_scripts/codex-zh-i18n.js` 并重启（或热重载拓展）。

## 在自己的仓库托管 Codex++（镜像，可选）

想让装本脚本的人"没装 Codex++ 就直接从**你的仓库**下载"：

1. 把 `codexplusplus/` 目录（`CodexPlusPlus-1.5.0-windows-x64-setup.exe` + `SHA256SUMS.txt` + `NOTICE.md`）上传到你的仓库（exe 约 23.7 MB，网页直接拖传或 git push 均可）。
2. 打开 `install.ps1`，把顶部的 `<YOUR_USERNAME>` 换成你的 GitHub 用户名（默认分支为 `main`；用其他分支/Release 地址就改成对应 URL）。本次发布已由 `zhudong1314` 填写好；若你 fork 后自行再托管，请改回你自己的用户名。
3. 完成后安装顺序为：你的镜像（带 SHA-256 钉扎校验）→ BigPizzaV3 官方最新版 → 手动链接。

## 已知限制

- **一键安装/卸载包仅 Windows**；macOS 需手动安装（见「平台支持」「手动安装」）；上游目前不发布 Codex++ Linux 版。
- **仅在使用 Codex++ 启动 Codex 时生效**（依赖 Codex++ 的 CDP 用户脚本注入）。
- Statsig gate 号 `72216192` 为**硬编码**：OpenAI 更新 Codex 后若 gate 变更会静默失效，需随新版更新该编号（与上游 codex-desktop-zh 相同限制）。
- 不修改 Codex 自身文件，不联网，不收集任何数据。

## 法律与许可说明

- **许可**：MIT。核心脚本 `codex-zh-i18n.js` 是 [codex-desktop-zh](https://github.com/shibaweidu/codex-desktop-zh) 中 `shared/i18n-bootstrap.js`（Copyright (c) 2026 Codex Zh Launcher contributors，MIT）的逐字衍生件，仅添加了许可头与幂等守卫；MIT 要求的原版权声明已按条款保留在本仓库 [LICENSE](LICENSE) 与脚本文件头部，随包附带完整 MIT 全文。
- **未包含其他项目的代码**：不含 xqnode/codex-zh-CN、不含 BigPizzaV3/CodexPlusPlus 的代码，仅运行时使用 Codex++ 自带的用户脚本注入机制（机制属功能接口，非代码拷贝）。
- **非官方**：与 OpenAI / Microsoft / BigPizzaV3 / shibaweidu / xqnode 均无隶属或背书关系。
- **风险提示（非法律意见）**：本脚本通过 patch Statsig 动态配置开关强制中文，属社区常见的汉化手段（上游项目同样做法）。若 OpenAI 后续更新 Statsig gate 或明确反对，脚本可能失效；商用再分发前请自行评估平台 ToS。
- **免责**：按 MIT "AS IS" 提供，无任何担保；使用者自行承担使用风险。
- **自动下载说明**：仅在用户确认后下载；优先本仓库 `codexplusplus/` 镜像（SHA-256 钉扎校验，不符即弃用），回落 BigPizzaV3/CodexPlusPlus 官方 GitHub Releases；不从任何第三方地址下载。
- **AGPL-3.0（Codex++ 本体）**：本仓库的 `codexplusplus/` 目录托管 BigPizzaV3/CodexPlusPlus（AGPL-3.0）v1.5.0 官方安装器的**未修改逐字节拷贝**，按 AGPL 条款保留许可声明并以上游仓库（tag v1.5.0）提供完整对应源代码，详见 `codexplusplus/NOTICE.md`。本仓库**未修改** Codex++ 代码；若你修改后再分发，须自行承担 AGPL-3.0 全部义务（含源码公开）。

## （可选）进 Codex++ 官方用户脚本市场

Codex++ 内置市场读取 `BigPizzaV3/CodexPlusPlusScriptMarket` 的 `index.json`。
如果想让所有人一键安装：向该仓库提 PR——把本脚本放进其 `scripts/` 目录，并把本仓库的 [`market-entry.json`](market-entry.json)（`author`/`homepage` 已填写）追加进 `index.json` 的 `scripts` 数组。
