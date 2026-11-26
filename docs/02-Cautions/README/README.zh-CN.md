# 注意事项

[English](../README.md) | [한국어](README.ko.md) | [日本語](README.ja.md) | **简体中文** | [Español](README.es.md) | [Français](README.fr.md)

![Read first](https://img.shields.io/badge/Read-before%20running-e53e3e?style=flat-square)

运行前请先读一遍。其中大部分是项目过程中真实遇到的情况。

## 目录

- [1. 脚本（真实的 Steam Deck）](#1-脚本真实的-steam-deck)
- [2. SteamOS 系统](#2-steamos-系统)
- [3. VMware 测试环境](#3-vmware-测试环境)
- [4. 真实 Steam Deck 上不需要的部分](#4-真实-steam-deck-上不需要的部分)

---

## 1. 脚本（真实的 Steam Deck）

- **第一次请用 `--dry-run` 运行。** 只显示将要安装或修改的内容，不做任何改动。
- **只有 `60-etc-keep` 模块需要 sudo。** 如果没有设置 deck 密码（`passwd`），该模块只记录警告并跳过，其他模块照常执行。
- **`dotfiles/` 中的文件会覆盖 `$HOME` 中的文件。** 内容不同时，会先把原文件备份到 `~/.local/state/steamos-unattended/backup/<时间>/`。
- **只向 `~/.bashrc` 添加一行**（读取 `~/.bash_aliases` 的那一行），已存在时不会重复添加。
- **首次运行需要 5～15 分钟**，因为要下载容器镜像和 Flatpak 应用。看起来卡住时也请耐心等待。
- **韩文输入从下次登录开始生效。** 切换键为 Ctrl+Space 或 한/영 键。
- **备份默认保存在 `~/Backups`。** 与系统在同一块磁盘上，无法防范设备故障。建议在 `config/backup.conf` 中改为 SD 卡或 NAS 路径。
- **不要把 `/etc/**` 这样宽泛的模式放进保留列表。** 这会阻止以后的 SteamOS 更新修改 `/etc`，导致问题。只写需要的文件。

---

## 2. SteamOS 系统

- **不要使用 `steamos-readonly disable`。** 本项目完全不触碰系统区域（`/usr`），安装在那里的东西会在更新时消失。
- **不要运行 `pacman -Sy`。** pacman 数据库位于只读区域，因此会失败；强行执行会导致系统软件包版本错乱。

---

## 3. VMware 测试环境

- **游戏模式在 VMware 中无法运行。** 虚拟 GPU 没有 Vulkan。点击 "Return to Gaming Mode" 会黑屏，通过 SSH 执行 `sudo reboot` 即可回到桌面。
- **安装后的系统进入桌面需要 1～2 分钟。** 黑屏时请至少等待 2 分钟。
- **SteamOS 内核更新后需要重新编译 vmwgfx 驱动。** 驱动服务不会阻止启动，可以通过 SSH 登录修复。
- **格式化磁盘前务必用 `lsblk` 确认名称和大小。** 误选恢复盘（`sda`）会毁掉工作环境。
- **请准确填写 `.vmx` 路径。** 路径错误会让 *那台* 虚拟机回滚到快照。虚拟机较多时尤其要小心。
- **确认命令是在哪里输入的。** `PS C:\…>` 是 Windows，`(deck@steamdeck ~)$` 是虚拟机内部。Windows 命令在虚拟机内无法执行。
- **在虚拟机中，한/영 键可能先被 Windows 或 VMware 截获。** 请使用 Ctrl+Space。

---

## 4. 真实 Steam Deck 上不需要的部分

[Configuration](../../03-Configuration/README/README.zh-CN.md) 的第 1～5 步（创建虚拟机、vmwgfx 驱动、修改安装脚本、桌面自动登录）**仅用于 VMware 测试环境**。在真实的 Steam Deck 上请跳过。
