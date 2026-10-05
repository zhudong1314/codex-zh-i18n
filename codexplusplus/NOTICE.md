# Codex++（CodexPlusPlus）v1.5.0 — 再分发许可说明

本目录包含 **BigPizzaV3** 发布的官方 Windows 安装器
`CodexPlusPlus-1.5.0-windows-x64-setup.exe`（23.7 MB）。

- 上游仓库：https://github.com/BigPizzaV3/CodexPlusPlus
- 上游许可：**AGPL-3.0**（完整许可文本见上游仓库 LICENSE）
- 本文件是官方 GitHub Release 资产的**逐字节拷贝**（未做任何修改）：
  - 来源：https://github.com/BigPizzaV3/CodexPlusPlus/releases/download/v1.5.0/CodexPlusPlus-1.5.0-windows-x64-setup.exe
  - SHA-256：`5F81231B1476AC6D3261541D78856C9B3574504C4240AE8376615694520D14B0`（见 SHA256SUMS.txt）

## AGPL-3.0 再分发合规说明

AGPL-3.0 允许原样再分发该二进制，前提：

1. **保留许可与版权信息**：本文件随附上游 AGPL-3.0 许可声明（本 NOTICE 即作为该声明载体之一，完整 LICENSE 文本请以上游仓库为准）；
2. **提供完整对应源代码**：v1.5.0 的完整源代码在 https://github.com/BigPizzaV3/CodexPlusPlus（tag `v1.5.0`），任何人可通过该地址获取；
3. **未修改**：本仓库没有修改 CodexPlusPlus 的任何源代码或二进制。若你后续修改了 CodexPlusPlus 并再分发，必须自行承担 AGPL-3.0 的全部义务（包括发布修改后的源代码，网络服务场景下触发 AGPL 第 13 条的远程提供条款）。

## 本目录用途

仅为「codex-zh-i18n 用户脚本 + Codex++」的一站式安装提供下载源
（`install.ps1` 未检测到 Codex++ 时优先从本仓库下载，其次回落到 BigPizzaV3 官方 Releases）。
本镜像与 BigPizzaV3 无任何隶属或背书关系。
